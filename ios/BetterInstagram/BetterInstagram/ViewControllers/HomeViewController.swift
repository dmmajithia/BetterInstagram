//
//  HomeViewController.swift
//  BetterInstagram
//
//  Created by Dhawal Majithia on 1/27/19.
//  Copyright © 2019 Dhawal Majithia. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITextFieldDelegate{
    
    //var user: User!
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var search: UITextField!
    var show_user_id: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        //Api.checkIfUserExists(fbID: "")
        //userLabel.text = user.username
        userLabel.text = "Hello " + (CurrentUser.shared.user?.username)!
        search.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(dismiss(noti:)), name: Notification.Name(rawValue: "dismmiss"), object: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        Api.makeRequest(endpoint: "search_username", data: ["username": textField.text!], completion: {(json) -> () in
            if(json["success"].bool!){
                self.show_user_id = String(json["user_id"].int!)
                self.performSegue(withIdentifier: "show_profile", sender: self)
            }
        })
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! ShowProfileVC
        destVC.show_user_id = self.show_user_id
    }
    @IBAction func myProfile(_ sender: Any) {
        self.show_user_id = CurrentUser.shared.user?.userID
        self.performSegue(withIdentifier: "show_profile", sender: self)
    }
    
    @objc func dismiss(noti: NSNotification){
        self.dismiss(animated: true, completion: nil)
    }
    
}
