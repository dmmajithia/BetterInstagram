//
//  User.swift
//  BetterInstagram
//
//  Created by Dhawal Majithia on 1/27/19.
//  Copyright © 2019 Dhawal Majithia. All rights reserved.
//

import Foundation
import SwiftyJSON

class User{
    var username: String
    var facebookID: String
    var accessToken: String
    var userID: String
    
    init(){ // for creating new empty user
        username = ""
        facebookID = ""
        accessToken = ""
        userID = ""
    }
    
    init(data: [String:String]){ //for data reading
        username = data["username"]!
        facebookID = data["facebookID"]!
        accessToken = data["accessToken"]!
        userID = data["userID"]!
    }
    
    func json(json: JSON){
        self.facebookID = json["facebook_id"].string!
        self.username = json["username"].string!
        self.userID = String(json["user_id"].int!)
    }
}
