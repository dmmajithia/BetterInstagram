//
//  CurrentUser.swift
//  BetterInstagram
//
//  Created by Dhawal Majithia on 1/28/19.
//  Copyright © 2019 Dhawal Majithia. All rights reserved.
//

import Foundation

class CurrentUser{
    
    static let shared = CurrentUser()
    var user: User?
    
    private init(){
        self.user = User.init()
    }
}
