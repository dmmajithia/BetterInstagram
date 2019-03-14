//
//  PostImageCell.swift
//  BetterInstagram
//
//  Created by Dhawal Majithia on 3/9/19.
//  Copyright © 2019 Dhawal Majithia. All rights reserved.
//

import UIKit

class PostImageCell: UITableViewCell{
    
    @IBOutlet weak var LabelLiked: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var activityInd: UIActivityIndicatorView!
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initialize(post: Post){
        self.post = post
        self.LabelLiked.isHidden = !self.post.isLiked() // hidden if not liked
        Api.getImage(url: post.url, userID: post.user_id, completion: {(image) -> () in
            self.postImage.image = image
            self.activityInd.stopAnimating()
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.doubleTapped(_:)))
            tap.numberOfTapsRequired = 2
            self.postImage.addGestureRecognizer(tap)
        })
    }
    
    @objc func doubleTapped(_ sender: Any){
        self.post.toggleLike(completion: {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "LikedPhoto"), object: nil)
        })
    }
}
