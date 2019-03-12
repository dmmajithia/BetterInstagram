//
//  PostCommentCell.swift
//  BetterInstagram
//
//  Created by Dhawal Majithia on 3/10/19.
//  Copyright © 2019 Dhawal Majithia. All rights reserved.
//

import UIKit
import DateToolsSwift

class PostCommentCell: UITableViewCell{
    
    @IBOutlet weak var LabelComment: UILabel!
    @IBOutlet weak var LabelTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initialize(post: Post, index: Int){
        let username = index == -1 ? post.user.username : post.comments[index]["username"].string!
        let text = index == -1 ? post.caption : post.comments[index]["text"].string!
        let attributedString = NSMutableAttributedString(string: username + " " + text!, attributes: [:])
        attributedString.addAttribute(.foregroundColor, value: UIColor.darkGray, range: NSRange(location: username.count, length: attributedString.length-username.count))
        self.LabelComment.attributedText = attributedString
        let timeAgoDate = Date(timeIntervalSinceNow: -post.timestamp/10000)
        self.LabelTime.text = timeAgoDate.timeAgoSinceNow
    }
}
