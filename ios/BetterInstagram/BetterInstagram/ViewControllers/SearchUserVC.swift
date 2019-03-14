//
//  SearchUserVC.swift
//  BetterInstagram
//
//  Created by Dhawal Majithia on 2/26/19.
//  Copyright © 2019 Dhawal Majithia. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchUserVC: UIViewController, UITextFieldDelegate{
    
    var usersArr = [JSON]()
    var show_user_id: String!
    
    @IBOutlet weak var ButtonLocation: UIButton!
    @IBOutlet weak var ButtonUser: UIButton!
    @IBOutlet weak var ButtonHashTag: UIButton!
    @IBOutlet weak var TextFieldSearch: UITextField!
    @IBOutlet weak var TableViewResults: UITableView!
    @IBOutlet weak var CollectionViewResults: UICollectionView!
    
    var selectedSearch = 0 // [user, hashtag, location]
    var buttons: [UIButton]!
    var currentSearchResponder: Searchable!
    
    override func viewDidLoad() {
        self.buttons = [self.ButtonUser, self.ButtonHashTag, self.ButtonLocation]
        self.hideKeyboardWhenTappedAround()
        self.TextFieldSearch.delegate = self
        self.TextFieldSearch.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        self.TableViewResults.register(UINib.init(nibName: "SearchUserCell", bundle: nil), forCellReuseIdentifier: "SearchUserCell")
        self.CollectionViewResults.register(UINib.init(nibName: "ActivityFeedPostCell", bundle: nil), forCellWithReuseIdentifier: "ActivityFeedPostCell")
        
        self.TableViewResults.tableFooterView = UIView(frame: .zero)
        
        self.updateSearchTabButtons(self.ButtonUser)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.updateSearch(text: textField.text!)
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.updateSearch(text: textField.text!)
    }
    
    func updateSearch(text: String){
        self.TextFieldSearch.text = text
        if(text.isEmpty){
            return
        }
        self.currentSearchResponder.updateSearch(searchText: text, parent: self, completion: {
            if self.selectedSearch == 0{
                self.TableViewResults.reloadData()
            }
            else{
                self.TableViewResults.isHidden = true
                self.CollectionViewResults.isHidden = false
                self.CollectionViewResults.reloadData()
            }
        })
    }
    
//    func dismissMe(){
//        NotificationCenter.default.post(name: Notification.Name(rawValue: "dismiss"), object: nil)
//        self.tabBarController?.selectedIndex = 0
//    }
    
    @IBAction func tappedCancel(_ sender: Any) {
        self.dismissMe()
        self.tabBarController?.selectedIndex = 0
    }
    
    @IBAction func updateSearchTabButtons(_ sender: UIButton){
        self.buttons[self.selectedSearch].backgroundColor = UIColor.clear
        self.selectedSearch = sender.tag
        self.buttons[self.selectedSearch].backgroundColor = UIColor.darkGray
        self.updateCurrentSearchResponder()
    }
    
    func updateCurrentSearchResponder(){
        self.TableViewResults.isHidden = self.selectedSearch == 2 // hidden if not searching users
        self.CollectionViewResults.isHidden = self.selectedSearch != 2
        
        switch self.selectedSearch {
        case 0:
            let userSearchable = SearchUser()
            self.TableViewResults.delegate = userSearchable
            self.TableViewResults.dataSource = userSearchable
            self.currentSearchResponder = userSearchable
            break
        case 1:
            let hashtagSearchable = SearchHashtag()
            self.CollectionViewResults.delegate = hashtagSearchable
            self.CollectionViewResults.dataSource = hashtagSearchable
            self.TableViewResults.delegate = hashtagSearchable
            self.TableViewResults.dataSource = hashtagSearchable
            self.currentSearchResponder = hashtagSearchable
            hashtagSearchable.showTophashtags(parent: self, completion: {
                self.TableViewResults.reloadData()
            })
            break
        default:
            let locationSearchable = SearchLocation()
            self.CollectionViewResults.delegate = locationSearchable
            self.CollectionViewResults.dataSource = locationSearchable
            self.currentSearchResponder = locationSearchable
        }
    }
    
    func showUser(userID: String){
        self.performSegue(withIdentifier: "user_profile", sender: userID)
    }
    
    func showPost(post: Post){
        self.performSegue(withIdentifier: "show_post", sender: post)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "user_profile":
            CurrentUser.shared.show_user_id = sender as! String
            let destVC = segue.destination as! UserProfileVC
            destVC.show_user_id = sender as? String
            return
        case "show_post":
            let destVC = segue.destination as! ViewPostVC
            destVC.post = sender as? Post
            return
        default:
            return
        }
    }
}
