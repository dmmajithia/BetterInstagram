//
//  ViewController.swift
//  BetterInstagram
//
//  Created by Dhawal Majithia on 1/26/19.
//  Copyright © 2019 Dhawal Majithia. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore

class LoginViewController: UIViewController, LoginButtonDelegate {
    
    var loggedIn: Bool!
    
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        if((AccessToken.current) != nil){ //user logged in using facebook
            CurrentUser.shared().user.facebookID = (AccessToken.current?.userId)!
            if(Api.checkIfUserExists(fbID: CurrentUser.shared().user.facebookID)){
                //go to main
            }
            else{
                //go to sign up
                self.loggedIn = true
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loggedIn = false
        // Do any additional setup after loading the view, typically from a nib.
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email, .userFriends ])
        loginButton.delegate = self
        loginButton.center = self.view.center
        self.view.addSubview(loginButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (self.loggedIn){
            DispatchQueue.main.async(){
                self.performSegue(withIdentifier: "signup", sender: nil)
            }
        }
    }
    
   /* func loggedIn(){
        var data: [String:String]
        data["username"] = "dmmajithia"
        data["fbID"] = "sdfasfsg"
        var user: User = User.init(data: data)
        
    }*/


}

