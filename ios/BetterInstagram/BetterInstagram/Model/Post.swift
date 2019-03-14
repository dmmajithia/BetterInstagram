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
    var mood: String!
    var timestamp: Double!
    var user: User!
    var userJson: JSON!
    var likes: [JSON]!
    var comments: [JSON]!
    
    func getPost(postID: String, completion: @escaping () -> ()){
        self.postID = postID
        Api.getPostData(postID: self.postID, completion: {(json) -> () in
            self.caption = json["caption"].string!
            self.user_id = String(json["user_id"].int!)
            self.location = json["location"].string!
            self.url = json["file_name"].string!
            self.timestamp = Double(json["timestamp"].string!)
            if let _mood = json["mood"].string{
                self.mood = _mood
            }
            User.getUserProfile(userID: self.user_id, completion: {(_user) -> () in
                self.user = _user
                completion()
            })
            //self.numLikes = json["num_of_likes"]
            //if(!CurrentUser.shared.isPersonalFeed){
                /*Api.makeRequest(endpoint: "profile/get_profile_data", data: ["user_id2": self.user_id,"user_id": (CurrentUser.shared.user?.userID)!], completion: {(json) -> () in
                    if(json["success"].bool!){
                        self.userJson = json
                        completion()
                    }
                })*/
            //}
            /*else{
                completion()
            }*/
        })
    }
    
    func getLikes(completion: @escaping () -> ()){
        Api.makeRequest(endpoint: "post/get_likes", data: ["post_id": self.postID], completion: {(json) -> () in
            self.likes = json["likes"].array
            completion()
        })
    }
    
    func getComments(completion: @escaping () -> ()){
        Api.makeRequest(endpoint: "post/get_comments", data: ["post_id": self.postID], completion: {(json) -> () in
            self.comments = json["comments"].array
            completion()
        })
    }
    
    func toggleLike(completion: @escaping ()->()){
        if self.isLiked(){
            //unlike the post
            //Api.makeRequest(endpoint: "post/unlike", data: <#T##[String : String]#>, completion: <#T##(JSON) -> ()#>)
        }
        else{
            //like the post
            Api.makeRequest(endpoint: "post/add_like", data: ["user_id": (CurrentUser.shared.user?.userID)!, "post_id": self.postID], completion: {(json) -> () in
                self.getLikes(completion: completion)
            })
        }
    }
    
    func isLiked() -> Bool{
        if self.likes == nil{
            return false
        }
        for like in self.likes{
            if String(like["user_id"].int!) == CurrentUser.shared.user?.userID{
                return true
            }
        }
        return false
    }
    
    func addComment(comment: String, completion: @escaping ()->()){
        Api.makeRequest(endpoint: "post/add_comment", data: ["user_id": (CurrentUser.shared.user?.userID)!, "post_id": self.postID, "text": comment, "timestamp": String(Date().timeIntervalSince1970)], completion: {(json) -> () in
            self.getComments(completion: completion)
        })
    }
    
}
