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
    
    func initialize(imageUrl: String, userID: String){
        Api.getImage(url: imageUrl, userID: userID, completion: {(image) -> () in
            self.postImage.image = image
            self.activityInd.stopAnimating()
        })
    }
}
