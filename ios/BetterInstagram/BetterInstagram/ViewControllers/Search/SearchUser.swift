//
//  SearchUser.swift
//  BetterInstagram
//
//  Created by Dhawal Majithia on 3/12/19.
//  Copyright © 2019 Dhawal Majithia. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchUser: NSObject, UITableViewDelegate, UITableViewDataSource, Searchable{
    
    var usersArr = [JSON]()
    var parent: SearchUserVC!
    
    //ignore START
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    //ignore END
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.usersArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchUserCell") as! SearchUserCell
        let user = self.usersArr[indexPath.item]
        cell.userID = String(user["user_id"].int!)
        cell.username = user["username"].string!
        cell.url = user["profile_picture"] == nil ? "2019-02-27_025933.838298_file.jpg" : user["profile_picture"].string!
        cell.initialize()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.parent.showUser(userID: (tableView.cellForRow(at: indexPath) as! SearchUserCell).userID)
    }
    
    func updateSearch(searchText: String, parent: SearchUserVC, completion: @escaping () -> ()) {
        self.parent = parent
        Api.searchUsername(text: searchText, completion: {(jsonArr) -> () in
            self.usersArr = jsonArr
            completion()
        })
    }
}
