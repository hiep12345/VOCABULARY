//
//  ViewController.swift
//  VOCABULARY
//
//  Created by lehiep on 5/13/18.
//  Copyright © 2018 lehiep. All rights reserved.
//

import UIKit
import ObjectMapper

class ItemCard:Mappable{
    var id:String?
    var word: String?
    var spell: String?
    var imgURL: String?
    var content:String?

    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        id           <- map["id"]
        word         <- map["word"]
        spell        <- map["spell"]
        imgURL       <- map["imgURL"]
        content      <- map["content"]
    }
}
