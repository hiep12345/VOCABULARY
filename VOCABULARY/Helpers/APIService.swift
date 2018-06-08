//
//  APIService.swift
//  VOCABULARY
//
//  Created by lehiep on 5/12/18.
//  Copyright © 2018 lehiep. All rights reserved.
//

import Foundation
import FirebaseDatabase
import ObjectMapper


public enum ServerErrorCodes:Int {
    case noMoreMovies = 10001
    case genericError = 20001
}

public enum ServerErrorMessages:String {
    case noMoreMovies = "No More Movies"
    case genericError = "Internet not connect"
}

public enum ServerError: Error {
    case systemError(Error)
    case customError(String)
    // add http status errors
    public var details:(code:Int, message:String){
        switch self {
        case .customError(let errorMesg):
            switch errorMesg {
            case "Movie not found!":
                return (ServerErrorCodes.noMoreMovies.rawValue,ServerErrorMessages.noMoreMovies.rawValue)
            default:
                return (ServerErrorCodes.genericError.rawValue,ServerErrorMessages.genericError.rawValue)
            }
        case .systemError(let errCode) :
            return (errCode._code,errCode.localizedDescription)
        }
    }
}

class APIService {
    static let sharedInstance = APIService()
    let ref = FIRDatabase.database().reference()
    
    // Load Item Cards
    func loadItemCards(day:String,idUser:String?,completionHandler: @escaping ([ItemCard]?,ServerError?)->Void){
        var path = "\(day)/Admin"
        if let id = idUser {
            path = "\(day)/\(id)"
        }
        
        self.ref.child(path).observeSingleEvent(of: .value, with: { (snapshot) in
             let value = snapshot
                .children
                .compactMap{$0 as? FIRDataSnapshot}
                .compactMap{$0.value as? [String:Any]}
                let arrayItemCards = Mapper<ItemCard>().mapArray(JSONArray: value)
            completionHandler(arrayItemCards,nil)
        })
    }
}
