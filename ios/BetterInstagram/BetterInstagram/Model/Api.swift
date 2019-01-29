//
//  Api.swift
//  BetterInstagram
//
//  Created by Dhawal Majithia on 1/28/19.
//  Copyright © 2019 Dhawal Majithia. All rights reserved.
//

import Foundation
import OHMySQL

struct Api{
    
    static func checkIfUserExists(fbID: String) -> Bool{
        let user = OHMySQLUser(userName: "dbmasteruser", password: "12345678", serverName: "ls-4c577f8ce2558da6e77b799294f2a69c0d455270.cyxr3j60i1wl.us-west-2.rds.amazonaws.com", dbName: "dbmaster", port: 3306, socket: "")
        let coordinator = OHMySQLStoreCoordinator(user: user!)
        coordinator.encoding = .UTF8MB4
        coordinator.connect()
        let queryString = "SELECT user_id, username, facebook_id FROM user WHERE user_id = 1"
        //let queryString = OHMySQLQueryRequestFactory.selectFirst("user", condition: "").queryString
        let query = OHMySQLQueryRequest.init(queryString: queryString)
        let response = try? OHMySQLContainer.shared.mainQueryContext?.executeQueryRequestAndFetchResult(query)
        NSLog(response.debugDescription)
        return false
    }
    
    static func addUserToDatabase(fbID: String, username: String){
        let user = OHMySQLUser(userName: "dbmasteruser", password: "12345678", serverName: "ls-4c577f8ce2558da6e77b799294f2a69c0d455270.cyxr3j60i1wl.us-west-2.rds.amazonaws.com", dbName: "dbmaster", port: 3306, socket: "")
        let coordinator = OHMySQLStoreCoordinator(user: user!)
        coordinator.encoding = .UTF8MB4
        coordinator.connect()
        //let queryString = "INSERT INTO user SET username = " + username + ", facebook_id = " + fbID
        let queryString = OHMySQLQueryRequestFactory.insert("user", set: ["username":username, "facebook_id":fbID]).queryString
        let query = OHMySQLQueryRequest.init(queryString: queryString)
        let response = try? OHMySQLContainer.shared.mainQueryContext?.executeQueryRequestAndFetchResult(query)
        NSLog(response.debugDescription)
    }
    
    
}
