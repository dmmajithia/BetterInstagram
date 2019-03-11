//
//  PostPosterCell.swift
//  BetterInstagram
//
//  Created by Dhawal Majithia on 3/10/19.
//  Copyright © 2019 Dhawal Majithia. All rights reserved.
//

import UIKit

class PostPosterCell: UITableViewCell{
    
    @IBOutlet weak var LabelUsername: UILabel!
    @IBOutlet weak var LabelLocation: UILabel!
    @IBOutlet weak var ImageProfile: UIImageView!
    
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initialize(post: Post){
        self.post = post
        self.LabelUsername.text = post.user.username
        self.LabelLocation.text = post.location
        Api.getImage(url: post.user.profilePictureUrl, userID: post.user_id, completion: {(image) -> () in
            self.ImageProfile.image = image
            self.ImageProfile.heightEqualsWidth()
            self.ImageProfile.setCornerRadius(radius: self.ImageProfile.frame.width/2)
            self.ImageProfile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.TappedUsername(_:))))
        })
        self.LabelUsername.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.TappedUsername(_:))))
        self.LabelLocation.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.TappedLocation(_:))))
        
    }
    @IBAction func TappedUsername(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "ShowUser"), object: self.post.user_id)
    }
    
    @IBAction func TappedLocation(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "ShowLocationForPost"), object: self.post)
    }
    
}
