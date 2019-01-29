//
//  Api.swift
//  BetterInstagram
//
//  Created by Dhawal Majithia on 1/28/19.
//  Copyright © 2019 Dhawal Majithia. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import FacebookCore

struct Api{
    
    static func checkIfUserExists(fbID: String) -> Bool{
        AF.request("http://127.0.0.1:5000/?fbID="+(AccessToken.current?.userId)!+"&function=check", method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
            case .failure(let error):
                print(error)
            }
        }
        //NSLog(response.debugDescription)
        return false
    }
    
    static func addUserToDatabase(fbID: String, username: String){
        AF.request("http://127.0.0.1:5000/?fbID="+fbID+"&function=insert&username="+username, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
}
