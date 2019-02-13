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
    override func viewDidLoad() {
        super.viewDidLoad()
        locationField.delegate = self
        self.hideKeyboardWhenTappedAround()
        
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
            Api.makeRequest(endpoint: "set_bio", data: ["user_id" : (CurrentUser.shared.user?.userID)!,
                                                        "bio" : bio], completion: {_ in })
            Api.makeRequest(endpoint: "set_website", data: ["user_id" : (CurrentUser.shared.user?.userID)!,
                                                            "website" : website], completion: {_ in })
            Api.makeRequest(endpoint: "set_location", data: ["user_id" : (CurrentUser.shared.user?.userID)!,
                                                             "location" : location], completion: {_ in })
            self.performSegue(withIdentifier: "main", sender: self)
        }
    }
    
}
