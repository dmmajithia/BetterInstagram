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
    var profilePictureUrl: String
    var isFollowed: Bool
    var tempImage: UIImage!
    
    init(){ // for creating new empty user
        username = ""
        facebookID = ""
        accessToken = ""
        userID = ""
        bio = ""
        website = ""
        location = ""
        profilePictureUrl = ""
        isFollowed = false
    }
    
    init(data: [String:String]){ //for data reading
        username = data["username"]!
        facebookID = data["facebookID"]!
        accessToken = data["accessToken"]!
        userID = data["userID"]!
        isFollowed = false
        bio = ""
        website = ""
        location = ""
        profilePictureUrl = ""
    }
    
    func json(json: JSON){
        //self.facebookID = json["facebook_id"].string!
        self.username = json["username"].string!
        self.userID = String(json["user_id"].int!)
        /*self.bio = json["bio"].string!
        self.location = json["location"].string!
        self.website = json["website"].string!
        self.profilePictureUrl = json["profile_picture_url"].string!*/
    }
    
    static func getUserProfile(userID: String, completion: @escaping (User) -> ()) {
        Api.getUserProfileJson(userID: userID, completion: {(json) -> () in
            let user = User()
            user.userID = userID
            user.username = json["username"].string!
            user.isFollowed = json["is_followed"].bool!
            user.bio = json["bio"].string!
            user.website = json["website"].string!
            user.location = json["location"].string!
            user.profilePictureUrl = json["profile_picture_url"].string!
            completion(user)
        })
    }
}
