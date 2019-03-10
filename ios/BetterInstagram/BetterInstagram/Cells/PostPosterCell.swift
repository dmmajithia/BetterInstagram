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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initialize(post: Post){
        self.LabelUsername.text = post.user.username
        self.LabelLocation.text = post.location
        Api.getImage(url: post.url, userID: post.user_id, completion: {(image) -> () in
            self.ImageProfile.image = image
            self.ImageProfile.setCornerRadius(radius: self.ImageProfile.frame.width/2)
        })
    }
}
