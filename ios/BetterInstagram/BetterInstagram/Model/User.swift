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
    var bio: String
    var website: String
    var location: String
    
    init(){ // for creating new empty user
        username = ""
        facebookID = ""
        accessToken = ""
        userID = ""
        bio = ""
        website = ""
        location = ""
    }
    
    init(data: [String:String]){ //for data reading
        username = data["username"]!
        facebookID = data["facebookID"]!
        accessToken = data["accessToken"]!
        userID = data["userID"]!
        bio = ""
        website = ""
        location = ""
    }
    
    func json(json: JSON){
        //self.facebookID = json["facebook_id"].string!
        self.username = json["username"].string!
        self.userID = String(json["user_id"].int!)
        /*self.bio = json["bio"].string!
        self.location = json["location"].string!
        self.website = json["website"].string!*/
    }
}
