//
//  SearchLocation.swift
//  BetterInstagram
//
//  Created by Dhawal Majithia on 3/12/19.
//  Copyright © 2019 Dhawal Majithia. All rights reserved.
//

import UIKit

class SearchLocation: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, Searchable, UICollectionViewDelegateFlowLayout{
    
    var postIDs: [Int]!
    var parent: SearchUserVC!
    
    //ignore START
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    //IGNORE END
    
    //PROTOCOL - CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.postIDs == nil{
            return 0
        }
        return self.postIDs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActivityFeedPostCell", for: indexPath) as! ActivityFeedPostCell
        cell.initialize(postID: (self.postIDs?[indexPath.item])!, personalize: false)
        cell.needsUpdateConstraints()
        cell.updateConstraints()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2, height: collectionView.frame.height / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        let post = (collectionView.cellForItem(at: indexPath) as! ActivityFeedPostCell).post
        self.parent.showPost(post: post!)
    }
    
    func updateSearch(searchText: String, parent: SearchUserVC, completion: @escaping () -> ()) {
        self.parent = parent
        self.postIDs = []
        Api.searchLocation(text: searchText, completion: {(_postIDs) -> () in
            self.postIDs = _postIDs
            completion()
        })
    }
}
