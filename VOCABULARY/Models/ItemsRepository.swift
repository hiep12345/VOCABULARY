//
//  ItemsRepository.swift
//  VOCABULARY
//
//  Created by lehiep on 6/2/18.
//  Copyright © 2018 lehiep. All rights reserved.
//

import UIKit

class ItemsRepository: NSObject {
    var itemCards:[ItemCard] = []
    let apiService = APIService.sharedInstance
    static let shared = ItemsRepository()
    
    func getAllItems(_ viewController: UIViewController, completion:@escaping(_ finished:Bool) -> Void) {
        apiService.loadItemCards(day: "12-05-2018", idUser: nil) { (itemCards, error) in
            if error == nil {
                self.itemCards = itemCards!
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    
    func getItemsRandomForGame1() -> ([ItemCard],ItemCard?){
        var arr:[ItemCard] = []
        var item:ItemCard?
        while arr.count < 4 {
            for _ in 0...itemCards.count{
                let randomInt = Int(arc4random_uniform(UInt32(itemCards.count)))
                if let _ = arr.index(where: { $0.word == itemCards[randomInt].word}) {
                }else{
                    arr.append(itemCards[randomInt])
                }
            }
        }
        print(arr.count)
        item = self.getItemRandomForGame1(arr: arr)
        return (arr,item)
    }
    
    func getItemRandomForGame1(arr:[ItemCard]) -> ItemCard?{
        var item:ItemCard?
        for _ in 0...arr.count{
            let randomInt = Int(arc4random_uniform(UInt32(arr.count)))
            item = arr[randomInt]
        }
        return item
    }
    
}
