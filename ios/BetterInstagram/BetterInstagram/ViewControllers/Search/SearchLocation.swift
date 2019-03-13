//
//  SearchLocation.swift
//  BetterInstagram
//
//  Created by Dhawal Majithia on 3/12/19.
//  Copyright © 2019 Dhawal Majithia. All rights reserved.
//

import UIKit

class SearchLocation: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, Searchable{
    
    var postIDs: [Int]!
    var isPersonalFeed = false
    var cells: [Int:ActivityFeedPostCell]!
    
    //ignore START
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    //IGNORE END
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    func updateSearch(searchText: String, parent: SearchUserVC, completion: @escaping () -> ()) {
        self.postIDs = []
        self.cells = [:]
        
    }
}
