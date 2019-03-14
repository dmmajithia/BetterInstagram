//
//  ViewPostVC.swift
//  BetterInstagram
//
//  Created by Dhawal Majithia on 3/10/19.
//  Copyright © 2019 Dhawal Majithia. All rights reserved.
//

import UIKit

class ViewPostVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(noti:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(noti:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.LikedPhoto(noti:)), name: Notification.Name(rawValue: "LikedPhoto"), object: nil)
        self.post.getLikes {
            self.post.getComments {
                self.commentTextField.delegate = self
                self.postTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.post != nil{
            if self.post.comments != nil{
                return (4 + self.post.comments.count)
            }
            return 4
        }
        return 0
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostLikesCell")
            //cell.initialize(post: self.post)
            cell?.detailTextLabel?.text = String(self.post.likes == nil ? 0 : self.post.likes.count)
            return cell!
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCommentCell") as! PostCommentCell
            cell.initialize(post: self.post, index: indexPath.item-4)
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
        if indexPath.item == 2{
            self.performSegue(withIdentifier: "ShowLikes", sender: self)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        let commentText = textField.text
        textField.text = ""
        self.post.addComment(comment: commentText!, completion: {
            self.postTableView.reloadData()
        })
        return true
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
    
    @objc func keyboardWillShow(noti: Notification){
        if let keyboardSize = (noti.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(noti: Notification){
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func LikedPhoto(noti: Notification){
        self.postTableView.reloadData()
    }
    
    @objc func showLikes(noti: Notification){
        self.performSegue(withIdentifier: "ShowLikes", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowLikes"{
            var userIDs = [String]()
            for user in self.post.likes{
                userIDs.append(String(user["user_id"].int!))
            }
            let destVC = segue.destination as! UserListVC
            destVC.userIDs = userIDs
            destVC.mainLabelText = "Likes"
            return
        }
    }
    
}
