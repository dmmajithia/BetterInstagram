//
//  CurrentUser.swift
//  BetterInstagram
//
//  Created by Dhawal Majithia on 1/28/19.
//  Copyright © 2019 Dhawal Majithia. All rights reserved.
//

import UIKit

class CurrentUser{
    
    static let shared = CurrentUser()
    var user: User?
    var isPersonalFeed = false
    var show_user_id = ""
    
    private init(){
        self.user = User.init()
    }
    
    static func setProfilePicture(image: UIImage, completion: @escaping () -> ()){
        Api.uploadImage(image: image, completion: {json in
            //self.performSegue(withIdentifier: "set_profile", sender: self)
            if(json["success"].bool!){
                let url = json["file_name"].string!
                Api.setProfilePictureUrl(url: url, completion: {
                    self.shared.user?.profilePictureUrl = url
                    completion()
                })
            }
        })
    }
}
