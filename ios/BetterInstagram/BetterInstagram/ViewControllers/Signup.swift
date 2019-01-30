//
//  Signup.swift
//  BetterInstagram
//
//  Created by Dhawal Majithia on 1/28/19.
//  Copyright © 2019 Dhawal Majithia. All rights reserved.
//

import UIKit
import FacebookCore

class SignupViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var userTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        userTextField.delegate = self
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        CurrentUser.shared.user!.username = textField.text!
        Api.addUserToDatabase(fbID: (AccessToken.current?.userId)!, username: textField.text!, completion: {(json) -> () in
            print(json)
        })
    return true
    }
    
}
