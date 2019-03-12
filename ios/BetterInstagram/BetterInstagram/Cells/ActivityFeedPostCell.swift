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
    
    func initialize(postID: Int, personalize: Bool){
        self.post = Post()
        self.post.getPost(postID: String(postID), completion: {
            Api.getImage(url: self.post.url, userID: self.post.user_id, completion: {(image) -> () in
                self.ImagePost.image = image
                self.ImagePost.setCornerRadius(radius: 5.0)
            })
            if(!personalize){
                Api.getImage(url: self.post.user.profilePictureUrl, userID: self.post.user_id, completion: {(image) -> () in
                    self.ImageProfile.image = image
                    self.ImageProfile.setCornerRadius(radius: self.ImageProfile.frame.width/2)
                    self.ImageProfile.layer.borderWidth = 2.0
                    self.ImageProfile.layer.borderColor = UIColor.white.cgColor
                })
            }
            self.ViewText.isHidden = true
            self.LabelCaption.text = self.post.caption
            self.LabelLocation.text = self.post.location
            //self.updateBackgroundFromMood()
        })
    }
    
    func updateBackgroundFromMood(){
        if(self.post.mood != nil){
            let rgb = self.post.mood.split(separator: ",")
            let r = CGFloat(Float(rgb[0])!)
            let g = CGFloat(Float(rgb[1])!)
            let b = CGFloat(Float(rgb[2])!)
            let bgColor = UIColor(displayP3Red: r/255, green: g/255, blue: b/255, alpha: 1.0)
            self.contentView.backgroundColor = bgColor
            self.backgroundView?.backgroundColor = bgColor
        }
        else{
            self.contentView.backgroundColor = UIColor.clear
        }
    }
    
    func toggleViewText(){
        self.ViewText.isHidden = !self.ViewText.isHidden
    }
}
