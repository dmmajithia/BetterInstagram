//
//  User.swift
//  BetterInstagram
//
//  Created by Dhawal Majithia on 1/27/19.
//  Copyright © 2019 Dhawal Majithia. All rights reserved.
//

import Foundation

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
}
