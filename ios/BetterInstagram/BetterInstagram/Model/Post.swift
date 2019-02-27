//
//  Post.swift
//  BetterInstagram
//
//  Created by Dhawal Majithia on 2/26/19.
//  Copyright © 2019 Dhawal Majithia. All rights reserved.
//

import Foundation
import SwiftyJSON

class Post{
    
    var postID: String!
    var caption: String!
    var location: String!
    var user_id: String!
    var numLikes: Int!
    var numComments: Int!
    var url: String!
    var userJson: JSON!
    
    func getPost(postID: String, completion: @escaping () -> ()){
        self.postID = postID
        Api.getPostData(postID: self.postID, completion: {(json) -> () in
            self.caption = json["caption"].string!
            self.user_id = String(json["user_id"].int!)
            self.location = json["location"].string!
            self.url = json["file_name"].string!
            //self.numLikes = json["num_of_likes"]
            if(!CurrentUser.shared.isPersonalFeed){
                Api.makeRequest(endpoint: "profile/get_profile_data", data: ["user_id2": self.user_id,"user_id": (CurrentUser.shared.user?.userID)!], completion: {(json) -> () in
                    if(json["success"].bool!){
                        self.userJson = json
                        completion()
                    }
                })
            }
            else{
                completion()
            }
        })
    }
    
}
