//
//  SetProfileVC.swift
//  BetterInstagram
//
//  Created by Dhawal Majithia on 2/12/19.
//  Copyright © 2019 Dhawal Majithia. All rights reserved.
//

import UIKit

class SetProfileVC: UIViewController, UITextFieldDelegate{
    
    
    @IBOutlet weak var bioField: UITextField!
    @IBOutlet weak var websiteField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    
    var updating = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationField.delegate = self
        self.hideKeyboardWhenTappedAround()
        if(updating){
            self.bioField.text = CurrentUser.shared.user?.bio
            self.locationField.text = CurrentUser.shared.user?.location
            self.websiteField.text = CurrentUser.shared.user?.website
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    @IBAction func finishTapped(_ sender: Any) {
        let bio = bioField.text!
        let website = websiteField.text!
        let location = locationField.text!
        
        if !(bio.isEmpty || website.isEmpty || location.isEmpty){
            //print(CurrentUser.shared.user?.userID!)
            Api.makeRequest(endpoint: "profile/set_bio", data: ["user_id" : (CurrentUser.shared.user?.userID)!,
                                                        "bio" : bio], completion: {_ in })
            Api.makeRequest(endpoint: "profile/set_website", data: ["user_id" : (CurrentUser.shared.user?.userID)!,
                                                            "website" : website], completion: {_ in })
            Api.makeRequest(endpoint: "profile/set_location", data: ["user_id" : (CurrentUser.shared.user?.userID)!,
                                                             "location" : location], completion: {_ in })
            if(updating){
                //dismiss me
                dismissMe()
            }
            else{
                self.performSegue(withIdentifier: "main", sender: self)
            }
        }
    }
    
//    func dismissMe(){
//        NotificationCenter.default.post(name: Notification.Name(rawValue: "dismiss"), object: nil)
//    }
    
}
