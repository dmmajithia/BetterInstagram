//
//  ViewController.swift
//  BetterInstagram
//
//  Created by Dhawal Majithia on 1/26/19.
//  Copyright © 2019 Dhawal Majithia. All rights reserved.
//

import UIKit
import FacebookLogin

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let loginButton = LoginButton(readPermissions: [.publicProfile])
        loginButton.center = self.view.center
        self.view.addSubview(loginButton)
    }


}

