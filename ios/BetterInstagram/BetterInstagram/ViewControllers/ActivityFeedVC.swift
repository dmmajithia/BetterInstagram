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
    var isPersonalFeed = false
    var cells: [Int:ActivityFeedPostCell]!
    
    override func viewDidLoad() {
        self.collectionView.register(UINib.init(nibName: "ActivityFeedPostCell", bundle: nil), forCellWithReuseIdentifier: "ActivityFeedPostCell")
        self.postIDs = []
    }
    
    func shouldPersonalize(should: Bool){
        self.isPersonalFeed = should
    }
    
    func updateViews(){
        if(self.isPersonalFeed){
            Api.getPosts(userID: (CurrentUser.shared.show_user_id), completion: {(ids) -> () in
                self.postIDs = ids
                self.collectionView.reloadData()
            })
        }
        else{
            Api.getActivityFeed(userID: (CurrentUser.shared.user?.userID)!, completion: {(ids) -> () in
                self.postIDs = ids
                self.collectionView.reloadData()
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.updateViews()
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
//        print("indexpath is ", indexPath.item)
//        if self.cells == nil{
//            self.cells = [:]
//        }
//        if !self.cells.isEmpty{
//            if let cell = self.cells[indexPath.item]{
//                return cell
//            }
//        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActivityFeedPostCell", for: indexPath) as! ActivityFeedPostCell
        cell.initialize(postID: (self.postIDs?[indexPath.item])!, personalize: self.isPersonalFeed)
        cell.needsUpdateConstraints()
        cell.updateConstraints()
        //self.cells[indexPath.item] = cell
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        //(collectionView.cellForItem(at: indexPath) as! ActivityFeedPostCell).toggleViewText()
        let post = (collectionView.cellForItem(at: indexPath) as! ActivityFeedPostCell).post
        self.performSegue(withIdentifier: "showPost", sender: post)
        //self.parent?.displayPost(post: post!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! ViewPostVC
        destVC.post = sender as! Post
    }
}
