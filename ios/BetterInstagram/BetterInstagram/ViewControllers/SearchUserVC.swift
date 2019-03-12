//
//  SearchUserVC.swift
//  BetterInstagram
//
//  Created by Dhawal Majithia on 2/26/19.
//  Copyright © 2019 Dhawal Majithia. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchUserVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate{
    
    var usersArr = [JSON]()
    var show_user_id: String!
    
    @IBOutlet weak var TextFieldSearch: UITextField!
    @IBOutlet weak var TableViewResults: UITableView!
    
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround()
        self.TableViewResults.register(UINib.init(nibName: "SearchUserCell", bundle: nil), forCellReuseIdentifier: "SearchUserCell")
        self.TableViewResults.delegate = self
        self.TableViewResults.dataSource = self
        self.TextFieldSearch.delegate = self
        self.TextFieldSearch.addTarget(self, action: #selector(self.textFieldDidChane(_:)), for: .editingChanged)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.updateSearch(text: textField.text!)
        return true
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        self.updateSearch(text: textField.text!)
//    }
    
    @objc func textFieldDidChane(_ textField: UITextField) {
        self.updateSearch(text: textField.text!)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.usersArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchUserCell") as! SearchUserCell
        let user = usersArr[indexPath.item]
        cell.userID = String(user["user_id"].int!)
        cell.username = user["username"].string!
        cell.url = user["profile_picture"].string!
        cell.initialize()
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.show_user_id = String((self.usersArr[indexPath.item])["user_id"].int!)
        self.performSegue(withIdentifier: "user_profile", sender: self)
    }
    
    func updateSearch(text: String){
        if(text.isEmpty){
            return
        }
        Api.searchUsername(text: text, completion: {(jsonArr) -> () in
            self.usersArr = jsonArr
            self.TableViewResults.reloadData()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //CurrentUser.shared.isPersonalFeed = true
        CurrentUser.shared.show_user_id = self.show_user_id
        let destVC = segue.destination as! UserProfileVC
        destVC.show_user_id = self.show_user_id
    }
    
//    func dismissMe(){
//        NotificationCenter.default.post(name: Notification.Name(rawValue: "dismiss"), object: nil)
//        self.tabBarController?.selectedIndex = 0
//    }
    
    @IBAction func tappedCancel(_ sender: Any) {
        self.dismissMe()
        self.tabBarController?.selectedIndex = 0
    }
}
