//
//  DetailCardViewController.swift
//  VOCABULARY
//
//  Created by MAC on 5/16/18.
//  Copyright © 2018 lehiep. All rights reserved.
//

import UIKit
import AVFoundation

class DetailCardViewController: UIViewController {
    var itemCard:ItemCard?
    
    @IBOutlet weak var word: UILabel!
    @IBOutlet weak var spell: UILabel!
    @IBOutlet weak var content: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.word.text = itemCard?.word
        self.spell.text = itemCard?.spell
        self.content.text = itemCard?.content
    }
    
    
    @IBAction func speaker(_ sender: Any) {
        let synth = AVSpeechSynthesizer()
        do {
            try AVAudioSession.sharedInstance().setCategory(
                AVAudioSessionCategoryPlayback,
                with: AVAudioSessionCategoryOptions.mixWithOthers
            )
            let utterance = AVSpeechUtterance(string:(itemCard?.word)!)
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
    @IBAction func Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
}
