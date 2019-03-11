//
//  Signup.swift
//  BetterInstagram
//
//  Created by Dhawal Majithia on 1/28/19.
//  Copyright © 2019 Dhawal Majithia. All rights reserved.
//

import UIKit
import LTMorphingLabel
import AwesomeTextFieldSwift
//import FacebookCore

class SignupViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var GreetDetailLabel: LTMorphingLabel!
    @IBOutlet weak var GreetLabel: LTMorphingLabel!
    //@IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var userTextField: AwesomeTextField!
    @IBOutlet weak var ErrorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        userTextField.delegate = self
        //self.view.layer.backgroundColor = UIColor.black
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.GreetDetailLabel.text = ""
        self.GreetDetailLabel.text = "Let's create a username for you"
        self.updateError(error: " ")
    }
    
    func updateError(error: String){
        self.ErrorLabel.text = error
    }
    
    func hideTextFieldPlaceholder(hide: Bool){
        //self.userTextField.placeholder = hide ? "" : "enter a username"
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.hideTextFieldPlaceholder(hide: !(textField.text?.isEmpty)!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = textField.text
        self.hideTextFieldPlaceholder(hide: !(textField.text?.isEmpty)!)
        view.endEditing(true)
        Api.checkUsername(username: text!, completion: {(json) -> () in
            if (json["existed"].bool!){
                //username already exists!
                self.updateError(error: "This username already exists!")
            }
            else{
                //sign up user
                self.updateError(error: " ")
                Api.signup(username: text!, completion: {(result) -> () in
                    CurrentUser.shared.user!.username = text!
                    CurrentUser.shared.user?.userID = String(result["user_id"].int!)
                    //segue to profile picture set
                    self.performSegue(withIdentifier: "set_profile_picture", sender: self)
                })
            }
        })
    return true
    }
    
}
