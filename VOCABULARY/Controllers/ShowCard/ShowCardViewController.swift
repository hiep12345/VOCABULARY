//
//  ShowCartViewController.swift
//  VOCABULARY
//
//  Created by MAC on 5/28/18.
//  Copyright © 2018 lehiep. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation

//MARK:VARIABLE
class ShowCardViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnPlay: UIButton!
    let itemRepository = ItemsRepository.shared
    fileprivate let reuseIdentifier = "CardCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 0.0, right: 0.0)
    fileprivate let itemsPerRow: CGFloat = 1
    fileprivate var itemCards:[ItemCard] = []
    var timer:Timer? = nil
    var isPlay = false {
        didSet{
            if isPlay{
                self.btnPlay.setImage(UIImage(named: "pause"), for: .normal)
            }else{
                self.btnPlay.setImage(UIImage(named: "play"), for: .normal)
            }
        }
    }
    
}
//MARK:LIFE CYCLE
extension ShowCardViewController {
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
extension ShowCardViewController {
    func setupData(){
        self.itemRepository.getAllItems(self) { (complete) in
            if complete{
                self.itemCards = self.itemRepository.itemCards
                self.collectionView.reloadData()
            }
        }
    }
    
    func setupView(){
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    func runSound(text:String){
        let synth = AVSpeechSynthesizer()
        do {
            try AVAudioSession.sharedInstance().setCategory(
                AVAudioSessionCategoryPlayback,
                with: AVAudioSessionCategoryOptions.mixWithOthers
            )
            let utterance = AVSpeechUtterance(string:text)
            utterance.rate = AVSpeechUtteranceDefaultSpeechRate
            let lang = "en_US"
            synth.continueSpeaking()
            utterance.voice = AVSpeechSynthesisVoice(language: lang)
            synth.continueSpeaking()
            synth.speak(utterance)
        } catch {
            print(error)
        }
    }

    @IBAction func autoNextNewWords(_ sender: Any) {
        if isPlay {
            self.isPlay = false
            self.timer?.invalidate()
        }else{
            self.isPlay = true
            self.reloadCollectionView()
        }
    }
    
    /*  List New Word */
    
    @IBAction func listNewWord(_ sender: Any) {
        self.navigationController?.isNavigationBarHidden = false
        let nextView                       = self.storyboard?.instantiateViewController(withIdentifier: "ListNewWords") as! ListNewWordsController
        nextView.itemCards                 = itemCards
        nextView.hidesBottomBarWhenPushed  = true
        nextView.modalTransitionStyle = .flipHorizontal
        nextView.modalPresentationStyle = .custom
        self.show(nextView, sender: self)
    }
}

//MARK:UICOLLECTIONVIEW itemCards, DELEGATE

extension ShowCardViewController:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.timer?.invalidate()
        let indexSelect = indexPath.row
        self.navigationController?.isNavigationBarHidden = false
        let nextView                       = self.storyboard?.instantiateViewController(withIdentifier: "DetailCard") as! DetailCardViewController
        nextView.itemCard                  = itemCards[indexSelect]
        nextView.hidesBottomBarWhenPushed  = true
        nextView.modalTransitionStyle = .flipHorizontal
        nextView.modalPresentationStyle = .custom
        self.show(nextView, sender: self)
    }
    
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let availableWidth = view.frame.width
        let widthPerItem = availableWidth
        let heightItem   = view.frame.height*5/7
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
    
    //After you've received data from server or you are ready with the itemCards, call this method. Magic!
    func reloadCollectionView() {
        
        self.collectionView.reloadData()
        
        // Invalidating timer for safety reasons
        self.timer?.invalidate()
        
        // Below, for each 2.0 seconds MyViewController's 'autoScrollImageSlider' would be fired
        self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(ShowCardViewController.autoScrollItemSlider), userInfo: nil, repeats: true)
        
        //This will register the timer to the main run loop
        RunLoop.main.add(self.timer!, forMode: .commonModes)
        
    }
    
    func scrollToPreviousOrNextCell(direction: String) {
        
        DispatchQueue.global(qos: .background).async {
            
            DispatchQueue.main.async {
                
                let firstIndex = 0
                let lastIndex = (self.itemCards.count) - 1
                let visibleIndices = self.collectionView.indexPathsForVisibleItems
                let nextIndex = visibleIndices[0].row + 1
                let previousIndex = visibleIndices[0].row - 1
                let nextIndexPath: IndexPath = IndexPath.init(item: nextIndex, section: 0)
                let previousIndexPath: IndexPath = IndexPath.init(item: previousIndex, section: 0)
                if direction == "Previous" {
                    if previousIndex < firstIndex {
                        
                        
                    } else {
                        
                        self.collectionView.scrollToItem(at: previousIndexPath, at: .centeredHorizontally, animated: true)
                    }
                    
                } else if direction == "Next" {
                    
                    if nextIndex > lastIndex {
                        
                        
                    } else {
                        
                        self.collectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
                        
                    }
                }
            }
        }
    }
    
    @objc func autoScrollItemSlider() {
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                let firstIndex = 0
                let lastIndex = (self.itemCards.count) - 1
                
                let visibleIndices = self.collectionView.indexPathsForVisibleItems
                let nextIndex = visibleIndices[0].row + 1
                
                let nextIndexPath: IndexPath = IndexPath.init(item: nextIndex, section: 0)
                let firstIndexPath: IndexPath = IndexPath.init(item: firstIndex, section: 0)
                
                if nextIndex > lastIndex {
                    self.runSound(text: self.itemCards[firstIndexPath.row].word!)
                    self.collectionView.scrollToItem(at: firstIndexPath, at: .centeredHorizontally, animated: true)
                    
                } else {
                    self.runSound(text: self.itemCards[nextIndexPath.row].word!)
                    self.collectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
                }
            }
        }
    }
    
    
}

