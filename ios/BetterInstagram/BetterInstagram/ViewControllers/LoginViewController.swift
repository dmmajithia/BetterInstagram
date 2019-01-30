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
    
    func afterFBLogin(){
        Api.checkIfUserExists(fbID: (AccessToken.current?.userId)!, completion: {(json) -> () in
            if(json["status"].bool!){
                //user exists
                CurrentUser.shared.user?.json(json: json)
                self.performSegue(withIdentifier: "segueToMain", sender: self)
            }
            else{
                //user does not exist
                self.performSegue(withIdentifier: "signup", sender: self)
            }
        })
    }
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        //self.afterFBLogin()
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
        if(AccessToken.current != nil){
            self.afterFBLogin()
        }
        /*if (self.loggedIn){
            DispatchQueue.main.async(){
                self.performSegue(withIdentifier: "signup", sender: nil)
            }
        }*/
    }
    
    func segueToMain(){
        //segue to login storyboard
        
    }
    
   /* func loggedIn(){
        var data: [String:String]
        data["username"] = "dmmajithia"
        data["fbID"] = "sdfasfsg"
        var user: User = User.init(data: data)
        
    }*/


}

