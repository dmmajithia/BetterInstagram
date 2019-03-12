//
//  MainTabBarController.swift
//  BetterInstagram
//
//  Created by Dhawal Majithia on 3/3/19.
//  Copyright © 2019 Dhawal Majithia. All rights reserved.
//

import UIKit
//import MaterialComponents.MaterialBottomNavigation

class MainTabBarController: UITabBarController{
    
    @IBOutlet var customTabBarView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customTabBarView.frame.size.width = self.view.frame.width
        self.customTabBarView.frame.size.height = self.view.frame.height*0.1
        self.customTabBarView.frame.origin.y = self.view.frame.height*0.92
        self.view.addSubview(self.customTabBarView)
    }
    
    @IBAction func changeTab(_ sender: UIButton) {
        self.selectedIndex = sender.tag
    }
    
}
