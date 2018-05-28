//
//  ViewController.swift
//  VOCABULARY
//
//  Created by lehiep on 5/12/18.
//  Copyright © 2018 lehiep. All rights reserved.
//

import UIKit
import AVFoundation
import Speech
import SDWebImage

//MARK:VARIABLE
class Game5ViewController: UIViewController,SFSpeechRecognizerDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var btnNextDetail: UIButton!
    @IBOutlet var textView : UITextField!
    
    fileprivate let reuseIdentifier = "CardCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 0.0, right: 0.0)
    fileprivate let itemsPerRow: CGFloat = 1
    fileprivate var itemCards:[ItemCard] = []
    let apiService = APIService.sharedInstance
    
    fileprivate let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en_US"))!
    
    fileprivate var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    fileprivate var recognitionTask: SFSpeechRecognitionTask?
    
    fileprivate let audioEngine = AVAudioEngine()
    
    var isNextItem:Bool? {
        didSet{
            if isNextItem == true {
                self.btnNextDetail.alpha = 0
            }
        }
    }
    
    var isTrueSpell:Bool? {
        didSet{
            if isTrueSpell == false {
                if textView.text == ""{
                    self.btnNextDetail.alpha = 0
                }else{
                    self.btnNextDetail.alpha = 1
                }
                self.btnNextDetail.setImage(UIImage(named:"ic_failure"), for: .normal)
            }else{
                if textView.text == ""{
                    self.btnNextDetail.alpha = 0
                }else{
                    self.btnNextDetail.alpha = 1
                }
                self.btnNextDetail.setImage(UIImage(named:"ic_true"), for: .normal)
            }
        }
    }
}
//MARK:LIFE CYCLE
extension Game5ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupData()
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
}


//MARK: OTHER FUNCTION
extension Game5ViewController {
    func setupData(){
        apiService.loadItemCards(day: "12-05-2018", idUser: nil) { (itemCards, error) in
            if error == nil {
                self.itemCards = itemCards!
                self.collectionView.reloadData()
            }
        }
    }
    
    func setupView(){
        self.isTrueSpell = false
        self.isNextItem = true
        self.textView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.startButton.isEnabled = false
        self.speechRecognizer.delegate = self
        SFSpeechRecognizer.requestAuthorization { authStatus in
            /*
             The callback may not be called on the main thread. Add an
             operation to the main queue to update the record button's state.
             */
            OperationQueue.main.addOperation {
                var isButtonEnabled = false
                
                switch authStatus {
                case .authorized:
                    isButtonEnabled = true
                    
                case .denied:
                    isButtonEnabled = false
                    print("User denied access to speech recognition")
                    
                case .restricted:
                    isButtonEnabled = false
                    print("Speech recognition restricted on this device")
                    
                case .notDetermined:
                    isButtonEnabled = false
                    print("Speech recognition not yet authorized")
                }
                
                OperationQueue.main.addOperation() {
                    self.startButton.isEnabled = isButtonEnabled
                }
            }
        }
    }
}

//MARK:UICOLLECTIONVIEW DATASOURCE, DELEGATE

extension Game5ViewController:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,numberOfItemsInSection section: Int) -> Int {
        return itemCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! CardWordCell
        cell.word.text = itemCards[indexPath.row].word
        cell.spell.text = itemCards[indexPath.row].spell
        cell.imgCard.sd_setImage(with: URL(string: itemCards[indexPath.row].imgURL!), placeholderImage:  UIImage(named: "noImage"), options: .refreshCached, completed: nil)
        return cell
    }
    
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let availableWidth = view.frame.width
        let widthPerItem = availableWidth
        let heightItem   = view.frame.height*4/5
        
        return CGSize(width: widthPerItem, height: heightItem)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    
    // 4
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.isNextItem = true
        audioEngine.stop()
        recognitionRequest?.endAudio()
        startButton.setImage(UIImage(named: "record"), for: .normal)
    }
}

//MARK:SPEECH DELEGATE --> Record and get text

extension Game5ViewController {
    
    //MARK: IBActions and Cancel
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        self.dectectStartRecord()
    }
    
    
    @IBAction func bntDetectNextDetail(_ sender: UIButton) {
        if isTrueSpell!{
            self.dectectStartRecord()
         
        }else{
            self.isNextItem = true
            audioEngine.stop()
            recognitionRequest?.endAudio()
            startButton.setImage(UIImage(named: "record"), for: .normal)
        }
    }
    
    func dectectStartRecord (){
        self.isNextItem = false
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            self.startButton.isEnabled = false
            startButton.setImage(UIImage(named: "record"), for: .normal)
        } else {
            startRecording()
            self.btnNextDetail.alpha = 0
            startButton.setImage(UIImage(named: "record_sellect"), for: .normal)
            
        }
    }
    
    func dectTrueOrFailure(textCompare:String,index:Int){
        let textTextField = self.textView.text
        if textTextField?.caseInsensitiveCompare(textCompare) == .orderedSame{
            self.isTrueSpell = true
        }else{
            self.isTrueSpell = false
        }
    }
    
    
    func startRecording() {
        if recognitionTask != nil {  //1
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()  //2
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()  //3
        
        let inputNode = audioEngine.inputNode
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        } //5
        
        recognitionRequest.shouldReportPartialResults = true  //6
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in  //7
            
            var isFinal = false  //8
            if result != nil {
                let text = result?.bestTranscription.formattedString
                //detect record true or failure
                if self.isNextItem  == false{
                    let indexPaths = self.collectionView.indexPathsForVisibleItems
                    let textCompare  = self.itemCards[(indexPaths.first?.row)!].word
                    self.dectTrueOrFailure(textCompare: textCompare!, index: (indexPaths.last?.row)!)
                }
                
                self.textView.text = text  //9
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {  //10
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
                self.startButton.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)  //11
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()  //12
        do {
            try audioEngine.start()
            
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        textView.text = "Say something, I'm listening!"
    }
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            startButton.isEnabled = true
        } else {
            startButton.isEnabled = false
        }
    }
    
    //MARK: - Alert
    func sendAlert(message: String) {
        let alert = UIAlertController(title: "Speech Recognizer Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: UITEXTFIELD DELEGATE
extension Game5ViewController:UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}

