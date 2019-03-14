//
//  SearchUserCell.swift
//  BetterInstagram
//
//  Created by Dhawal Majithia on 2/26/19.
//  Copyright © 2019 Dhawal Majithia. All rights reserved.
//

import UIKit

class SearchUserCell: UITableViewCell{
    
    var userID: String!
    var username: String!
    var url: String!
    
    @IBOutlet weak var ImageProfile: UIImageView!
    @IBOutlet weak var LabelUsername: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initialize(){
        self.LabelUsername.text = self.username
        if self.url == nil{
            return
        }
        Api.getImage(url: self.url, userID: self.userID, completion: {(image) -> () in
            self.ImageProfile.image = image
            self.ImageProfile.layer.cornerRadius = self.ImageProfile.frame.width/2
        })
    }
}
