//
//  Signup.swift
//  BetterInstagram
//
//  Created by Dhawal Majithia on 1/28/19.
//  Copyright © 2019 Dhawal Majithia. All rights reserved.
//

import UIKit
//import FacebookCore

class SignupViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var userTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        userTextField.delegate = self
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        CurrentUser.shared.user!.username = textField.text!
        Api.makeRequest(endpoint: "signup", data: ["appID" : Api.appID, "username" : textField.text!], completion: {(json) -> () in
            print(json)
            CurrentUser.shared.user?.userID = String(json["user_id"].int!)
            CurrentUser.shared.user?.username = textField.text!
            //segue to profile picture set
            self.performSegue(withIdentifier: "set_profile_picture", sender: self)
        })
    return true
    }
    
}
