//
//  UserProfileVC.swift
//  BetterInstagram
//
//  Created by Dhawal Majithia on 2/26/19.
//  Copyright © 2019 Dhawal Majithia. All rights reserved.
//

import UIKit
import SwiftyJSON
import YPImagePicker

class UserProfileVC: UIViewController{
    
    var json: JSON!
    var show_user_id: String!
    var is_followed: Bool!
    var is_editing = false
    
    @IBOutlet weak var LabelUsername: UILabel!
    @IBOutlet weak var LabelBio: UILabel!
    @IBOutlet weak var LabelLocation: UILabel!
    @IBOutlet weak var LabelWebsite: UILabel!
    @IBOutlet weak var ImageProfile: UIImageView!
    @IBOutlet weak var ButtonFollow: UIButton!
    @IBOutlet weak var ButtonCancel: UIButton!
    
    
    override func viewDidLoad() {
        self.is_followed = false
        self.addEditActions()
        if(self.show_user_id == nil){
            self.show_user_id = CurrentUser.shared.user?.userID
            CurrentUser.shared.show_user_id = self.show_user_id
        }
        (self.children.last as! ActivityFeedVC).shouldPersonalize(should: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.updateUser()
        //self.is_editing = false
        if(self.is_editing){
            self.toggleEdit()
        }
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
            Api.makeRequest(endpoint: "relationship/unfollow", data: ["user_id2": self.show_user_id,
                                                         "user_id": (CurrentUser.shared.user?.userID)!], completion: {_ in
                                                            self.updateUser()
            })
        }
        else if (self.show_user_id != CurrentUser.shared.user?.userID){
            //follow
            Api.makeRequest(endpoint: "relationship/follow", data: ["user_id2": self.show_user_id,
                                                       "user_id": (CurrentUser.shared.user?.userID)!], completion: {_ in
                                                        self.updateUser()
            })
        }
        else{
            //edit
            self.toggleEdit()
        }
        //self.updateUser()
    }
    
    func toggleEdit(){
        self.is_editing = !self.is_editing
        if(self.is_editing){
            self.ImageProfile.layer.borderWidth = 2.0
            self.ImageProfile.layer.borderColor = UIColor.blue.cgColor
            self.LabelLocation.textColor = UIColor.blue
            self.LabelBio.textColor = UIColor.blue
            self.LabelWebsite.textColor = UIColor.blue
        }
        else{
            self.ImageProfile.layer.borderWidth = 0
            self.ImageProfile.layer.borderColor = UIColor.blue.cgColor
            self.LabelLocation.textColor = UIColor.white
            self.LabelBio.textColor = UIColor.white
            self.LabelWebsite.textColor = UIColor.white
        }
    }
    
    func addEditActions(){
        self.ImageProfile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.changeProfilePicture(_:))))
        self.LabelWebsite.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.changeText(_:))))
        self.LabelBio.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.changeText(_:))))
        self.LabelLocation.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.changeText(_:))))
    }
    
    @objc func changeText(_ sender: Any){
        if(self.is_editing){
            self.performSegue(withIdentifier: "changeProfileData", sender: self)
        }
    }
    
    @objc func changeProfilePicture(_ sender: Any){
        if(!self.is_editing){
            return
        }
        let picker = YPImagePicker()
        picker.didFinishPicking { [unowned picker] items, cancelled in
            if cancelled{
                print("image picker cancelled")
            }
            if let photo = items.singlePhoto {
                CurrentUser.setProfilePicture(image: photo.image, completion: {
                    self.updateUser()
                })
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    
    func dismissMe(){
        NotificationCenter.default.post(name: Notification.Name(rawValue: "dismiss"), object: nil)
    }
    
    @IBAction func TappedCancel(_ sender: Any) {
        if(self.tabBarController != nil){
            self.tabBarController?.selectedIndex = 0
        }
        else{
            self.dismissMe()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "changeProfileData"){
            let destVC = segue.destination as! SetProfileVC
            destVC.updating = true
        }
        else if(segue.identifier == "showWeb"){
            
        }
    }
}
