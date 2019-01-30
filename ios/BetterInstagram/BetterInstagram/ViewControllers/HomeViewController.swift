//
//  HomeViewController.swift
//  BetterInstagram
//
//  Created by Dhawal Majithia on 1/27/19.
//  Copyright © 2019 Dhawal Majithia. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController{
    
    //var user: User!
    
    @IBOutlet weak var userLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Api.checkIfUserExists(fbID: "")
        //userLabel.text = user.username
        userLabel.text = CurrentUser.shared.user?.username
    }
    
}
