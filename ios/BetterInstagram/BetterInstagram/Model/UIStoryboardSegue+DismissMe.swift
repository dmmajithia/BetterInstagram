//
//  UIStoryboardSegue+DismissMe.swift
//  BetterInstagram
//
//  Created by Dhawal Majithia on 3/11/19.
//  Copyright © 2019 Dhawal Majithia. All rights reserved.
//

import UIKit

class UIStoryboardSegueDismissMe: UIStoryboardSegue{
    
    override func perform() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "SetParent"), object: self.source)
        super.perform()
    }
    
}
