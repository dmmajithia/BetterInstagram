//
//  PostCommentCell.swift
//  BetterInstagram
//
//  Created by Dhawal Majithia on 3/10/19.
//  Copyright © 2019 Dhawal Majithia. All rights reserved.
//

import UIKit

class PostCommentCell: UITableViewCell{
    
    @IBOutlet weak var LabelComment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initialize(post: Post){
        let attributedString = NSMutableAttributedString(string: post.user.username + " " + post.caption, attributes: [:])
        attributedString.addAttribute(.foregroundColor, value: UIColor.darkGray, range: NSRange(location: post.user.username.count, length: attributedString.length-post.user.username.count-1))
        self.LabelComment.attributedText = attributedString
    }
}
