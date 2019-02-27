//
//  ActivityFeedPostCell.swift
//  BetterInstagram
//
//  Created by Dhawal Majithia on 2/26/19.
//  Copyright © 2019 Dhawal Majithia. All rights reserved.
//

import UIKit

class ActivityFeedPostCell: UICollectionViewCell{
    
    @IBOutlet weak var ImageProfile: UIImageView!
    @IBOutlet weak var ImagePost: UIImageView!
    @IBOutlet weak var LabelLocation: UILabel!
    @IBOutlet weak var LabelCaption: UILabel!
    @IBOutlet weak var ViewText: UIView!
    
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initialize(postID: Int){
        self.post = Post()
        self.post.getPost(postID: String(postID), completion: {
            Api.getImage(url: self.post.url, userID: self.post.user_id, completion: {(image) -> () in
                self.ImagePost.image = image
                self.ImagePost.setCornerRadius(radius: 5.0)
            })
            if(!CurrentUser.shared.isPersonalFeed){
                Api.getImage(url: self.post.userJson["profile_picture_url"].string!, userID: self.post.user_id, completion: {(image) -> () in
                    self.ImageProfile.image = image
                    self.ImageProfile.setCornerRadius(radius: self.ImageProfile.frame.width/2)
                    self.ImageProfile.layer.borderWidth = 2.0
                    self.ImageProfile.layer.borderColor = UIColor.white.cgColor
                })
            }
            self.ViewText.isHidden = true
            self.LabelCaption.text = self.post.caption
            self.LabelLocation.text = self.post.location
        })
    }
    
    func toggleViewText(){
        self.ViewText.isHidden = !self.ViewText.isHidden
    }
}
