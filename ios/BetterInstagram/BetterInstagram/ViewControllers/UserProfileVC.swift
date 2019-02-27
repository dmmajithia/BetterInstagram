//
//  UserProfileVC.swift
//  BetterInstagram
//
//  Created by Dhawal Majithia on 2/26/19.
//  Copyright © 2019 Dhawal Majithia. All rights reserved.
//

import UIKit
import SwiftyJSON

class UserProfileVC: UIViewController{
    
    var json: JSON!
    var show_user_id: String!
    var is_followed: Bool!
    
    @IBOutlet weak var LabelUsername: UILabel!
    @IBOutlet weak var LabelBio: UILabel!
    @IBOutlet weak var LabelLocation: UILabel!
    @IBOutlet weak var LabelWebsite: UILabel!
    @IBOutlet weak var ImageProfile: UIImageView!
    @IBOutlet weak var ButtonFollow: UIButton!
    @IBOutlet weak var ButtonCancel: UIButton!
    
    
    override func viewDidLoad() {
        self.is_followed = false
        self.updateUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func updateUser(){
        Api.makeRequest(endpoint: "profile/get_profile_data", data: ["user_id2": self.show_user_id,"user_id": (CurrentUser.shared.user?.userID)!], completion: {(json) -> () in
            if(json["success"].bool!){
                self.json = json
                self.updateView()
            }
            else{
                //could not fetch user profile!!!
                self.dismissMe()
            }
        })
    }
    
    func updateView(){
        self.LabelUsername.text = json["username"].string!
        if(json["is_followed"].bool!){
            self.is_followed = true
            self.ButtonFollow.text("Unfollow")
        }
        if(self.show_user_id == CurrentUser.shared.user?.userID){
            self.ButtonFollow.text("Edit")
        }
        self.LabelBio.text(json["bio"].string!)
        self.LabelWebsite.text(json["website"].string!)
        self.LabelLocation.text(json["location"].string!)
        self.ImageProfile.layer.cornerRadius = self.ImageProfile.frame.width/2
        Api.getImage(url: json["profile_picture_url"].string!, userID: self.show_user_id, completion: {(image) -> () in
            self.ImageProfile.image = image
            self.ImageProfile.setCornerRadius(radius: self.ImageProfile.frame.width/2)
        })
    }
    @IBAction func TappedFollow(_ sender: Any) {
        if(self.is_followed){
            //unfollow
            Api.makeRequest(endpoint: "unfollow", data: ["user_id2": self.show_user_id,
                                                         "user_id": (CurrentUser.shared.user?.userID)!], completion: {_ in })
        }
        else if (self.show_user_id != CurrentUser.shared.user?.userID){
            //follow
            Api.makeRequest(endpoint: "follow", data: ["user_id2": self.show_user_id,
                                                       "user_id": (CurrentUser.shared.user?.userID)!], completion: {_ in })
        }
        else{
            //edit
        }
        self.updateUser()
    }
    
    func dismissMe(){
        NotificationCenter.default.post(name: Notification.Name(rawValue: "dismiss"), object: nil)
    }
    
    @IBAction func TappedCancel(_ sender: Any) {
        self.dismissMe()
    }
}
