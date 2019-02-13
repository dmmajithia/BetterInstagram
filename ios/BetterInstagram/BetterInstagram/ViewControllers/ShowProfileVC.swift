//
//  showProfile.swift
//  BetterInstagram
//
//  Created by Dhawal Majithia on 2/12/19.
//  Copyright © 2019 Dhawal Majithia. All rights reserved.
//

import UIKit

class ShowProfileVC: UIViewController{
    
    var show_user_id: String!
    var is_followed: Bool!
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var bio: UILabel!
    @IBOutlet weak var website: UILabel!
    @IBOutlet weak var location: UILabel!
    
    
    @IBAction func back(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "dismmiss"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.is_followed = false
        Api.makeRequest(endpoint: "get_profile_data", data: ["user_id2": self.show_user_id,
                                                             "user_id": (CurrentUser.shared.user?.userID)!], completion: {(json) -> () in
            if(json["success"].bool!){
                self.username.text = json["username"].string!
                if(json["is_followed"].bool!){
                    self.is_followed = true
                    self.followButton.text("Unfollow")
                }
                if(self.show_user_id == CurrentUser.shared.user?.userID){
                    self.followButton.text("Edit profile")
                    self.followButton.isEnabled = false
                }
                self.bio.text(json["bio"].string!)
                self.website.text(json["website"].string!)
                self.location.text(json["location"].string!)
                
            }
        })
        
    }
    @IBAction func followTapped(_ sender: Any) {
        if(self.show_user_id != CurrentUser.shared.user?.userID && !self.is_followed){
            Api.makeRequest(endpoint: "follow", data: ["user_id2": self.show_user_id,
                                                       "user_id": (CurrentUser.shared.user?.userID)!], completion: {_ in })
        }
        else if(self.show_user_id != CurrentUser.shared.user?.userID){
            Api.makeRequest(endpoint: "unfollow", data: ["user_id2": self.show_user_id,
                                                       "user_id": (CurrentUser.shared.user?.userID)!], completion: {_ in })
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "dismmiss"), object: nil)
    }
    
}
