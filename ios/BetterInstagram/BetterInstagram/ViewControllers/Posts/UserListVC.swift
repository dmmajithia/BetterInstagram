//
//  LikersVC.swift
//  BetterInstagram
//
//  Created by Dhawal Majithia on 3/13/19.
//  Copyright © 2019 Dhawal Majithia. All rights reserved.
//

import UIKit

class UserListVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var userIDs: [String]!
    var mainLabelText: String!
    
    @IBOutlet weak var TableViewUsers: UITableView!
    @IBOutlet weak var LabelMain: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.mainLabelText != nil{
            self.LabelMain.text = mainLabelText
        }
        self.TableViewUsers.delegate = self
        self.TableViewUsers.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.userIDs == nil{
            return 0
        }
        return self.userIDs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostLikerCell")
        User.getUserProfile(userID: self.userIDs[indexPath.item], completion: {(user) -> () in
            cell?.textLabel?.text = user.username
            Api.getImage(url: user.profilePictureUrl, userID: self.userIDs[indexPath.item], completion: {(image) -> () in
            cell?.imageView?.image = image
            cell?.imageView?.setCornerRadius(radius: (cell?.imageView?.frame.width)!)
            })
        })
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.showUser(userID: self.userIDs[indexPath.item])
    }
    
    func showUser(userID: String){
        let showUserVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileVC
        showUserVC.show_user_id = userID
        NotificationCenter.default.post(name: Notification.Name(rawValue: "SetParent"), object: self)
        self.show(showUserVC, sender: self)
    }
    @IBAction func TappedBack(_ sender: Any) {
        self.dismissMe()
    }
}
