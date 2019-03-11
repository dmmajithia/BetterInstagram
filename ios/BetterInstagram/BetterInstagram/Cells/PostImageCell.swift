//
//  PostImageCell.swift
//  BetterInstagram
//
//  Created by Dhawal Majithia on 3/9/19.
//  Copyright © 2019 Dhawal Majithia. All rights reserved.
//

import UIKit

class PostImageCell: UITableViewCell{
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var activityInd: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initialize(post: Post){
        Api.getImage(url: post.url, userID: post.user_id, completion: {(image) -> () in
            self.postImage.image = image
            self.activityInd.stopAnimating()
        })
    }
}
