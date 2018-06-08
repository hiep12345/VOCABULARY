//
//  TabViewController.swift
//  VOCABULARY
//
//  Created by lehiep on 5/12/18.
//  Copyright © 2018 lehiep. All rights reserved.
//

import UIKit

class TabMainViewController: UITabBarController{
    let arrayOfImageNamebState = ["tickets","add"]
    let arrayOfImageNameForselectedState = ["tickets_sellect","add_sellect"]
    
}
//MARK:LIFE CYCLE
extension TabMainViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupData()
        self.setupView()
    }
}

//MARK: OTHER METHOD
extension TabMainViewController{
    
    func setupView(){
        
        if let count = self.tabBar.items?.count {
            for i in 0...(count-1) {
                let imageNameForSelectedState   = arrayOfImageNameForselectedState[i]
                let imageNameForUnselectedState = arrayOfImageNamebState[i]
                
                self.tabBar.items?[i].selectedImage = UIImage(named: imageNameForSelectedState)?.withRenderingMode(.alwaysOriginal)
                self.tabBar.items?[i].image = UIImage(named: imageNameForUnselectedState)?.withRenderingMode(.alwaysOriginal)
            }
        }
        let selectedColor   = UIColor(red: 21/255.0, green: 155/255.0, blue: 74/255.0, alpha: 1.0)
        let unselectedColor = UIColor.gray
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: unselectedColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: selectedColor], for: .selected)
    }
    
    func setupData(){
        
        
    }
}



