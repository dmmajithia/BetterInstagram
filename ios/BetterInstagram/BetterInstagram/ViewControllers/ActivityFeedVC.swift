//
//  ActivityFeedVC.swift
//  BetterInstagram
//
//  Created by Dhawal Majithia on 2/26/19.
//  Copyright © 2019 Dhawal Majithia. All rights reserved.
//

import UIKit

class ActivityFeedVC: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    var postIDs: [Int]!
    
    override func viewDidLoad() {
        self.collectionView.register(UINib.init(nibName: "ActivityFeedPostCell", bundle: nil), forCellWithReuseIdentifier: "ActivityFeedPostCell")
        self.postIDs = []
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Api.getPosts(userID: (CurrentUser.shared.user?.userID)!, completion: {(ids) -> () in
            self.postIDs = ids
            self.collectionView.reloadData()
        })
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if(postIDs.count == 0){
            return 0
        }
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postIDs.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActivityFeedPostCell", for: indexPath) as! ActivityFeedPostCell
        cell.initialize(postID: (self.postIDs?[indexPath.item])!)
        cell.needsUpdateConstraints()
        cell.updateConstraints()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2.2, height: collectionView.frame.height / 2.2)
    }
}
