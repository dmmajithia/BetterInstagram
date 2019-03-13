//
//  SearchProtocol.swift
//  BetterInstagram
//
//  Created by Dhawal Majithia on 3/12/19.
//  Copyright © 2019 Dhawal Majithia. All rights reserved.
//

import UIKit

protocol Searchable: UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    func updateSearch(searchText: String, parent: SearchUserVC, completion: @escaping () -> ()) -> ()
    
}
