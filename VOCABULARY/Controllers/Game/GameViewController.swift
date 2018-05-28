//
//  GameViewController.swift
//  VOCABULARY
//
//  Created by MAC on 5/28/18.
//  Copyright © 2018 lehiep. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func ac_Start(_ sender: Any) {
        self.navigationController?.isNavigationBarHidden = false
        let nextView                       = self.storyboard?.instantiateViewController(withIdentifier: "Practice") as! PracticeViewController
        nextView.hidesBottomBarWhenPushed  = true
        nextView.modalTransitionStyle = .flipHorizontal
        nextView.modalPresentationStyle = .custom
        self.navigationController?.show(nextView, sender: self)
        
    }
    
    
    @IBAction func ac_Schedule(_ sender: Any) {
        
        
        
    }
    
}
