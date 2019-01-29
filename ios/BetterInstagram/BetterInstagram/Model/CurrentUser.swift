//
//  CurrentUser.swift
//  BetterInstagram
//
//  Created by Dhawal Majithia on 1/28/19.
//  Copyright © 2019 Dhawal Majithia. All rights reserved.
//

import Foundation

class CurrentUser{
    private static var sharedCurrentUser: CurrentUser{
        let currentUser = CurrentUser(user: User.init())
        return currentUser
    }
    
    private init(user: User) {
        self.user = user
    }
    
    let user: User
    
    class func shared() -> CurrentUser {
        return sharedCurrentUser
    }
}
