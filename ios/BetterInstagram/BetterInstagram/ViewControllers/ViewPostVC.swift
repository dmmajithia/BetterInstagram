//
//  ViewPostVC.swift
//  BetterInstagram
//
//  Created by Dhawal Majithia on 3/10/19.
//  Copyright © 2019 Dhawal Majithia. All rights reserved.
//

import UIKit

class ViewPostVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var postTableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    
    var post: Post!
    
    
    override func viewDidLoad() {
        self.postTableView.delegate = self
        self.postTableView.dataSource = self
        self.postTableView.register(UINib.init(nibName: "PostCommentCell", bundle: nil), forCellReuseIdentifier: "PostCommentCell")
        self.postTableView.register(UINib.init(nibName: "PostActionCell", bundle: nil), forCellReuseIdentifier: "PostActionCell")
        self.postTableView.register(UINib.init(nibName: "PostPosterCell", bundle: nil), forCellReuseIdentifier: "PostPosterCell")
        self.postTableView.register(UINib.init(nibName: "PostImageCell", bundle: nil), forCellReuseIdentifier: "PostImageCell")
        NotificationCenter.default.addObserver(self, selector: #selector(self.showUser(noti:)), name: Notification.Name(rawValue: "ShowUser"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showLocationForPost(noti:)), name: Notification.Name(rawValue: "ShowLocationForPost"), object: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.item{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostPosterCell") as! PostPosterCell
            cell.initialize(post: self.post)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostImageCell") as! PostImageCell
            cell.initialize(post: self.post)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostActionCell") as! PostActionCell
            cell.initialize(post: self.post)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCommentCell") as! PostCommentCell
            cell.initialize(post: self.post)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.item{
        case 0:
            return 60.0
        case 1:
            return self.view.frame.width
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    @IBAction func TappedBack(_ sender: Any) {
        self.dismissMe()
    }
    
    @objc func showUser(noti: Notification){
        let userID = noti.object as! String
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let showUserVC = mainStoryboard.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileVC
        showUserVC.show_user_id = userID
        CurrentUser.shared.show_user_id = userID
        NotificationCenter.default.post(name: Notification.Name(rawValue: "SetParent"), object: self)
        self.show(showUserVC, sender: self)
    }
    
    @objc func showLocationForPost(noti: Notification){
        
    }
    
}
