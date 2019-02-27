//
//  MainVC.swift
//  BetterInstagram
//
//  Created by Dhawal Majithia on 2/26/19.
//  Copyright © 2019 Dhawal Majithia. All rights reserved.
//

import UIKit
import YPImagePicker

class MainVC: UIViewController{
    
    
    @IBOutlet weak var LabelUsername: UILabel!
    
    override func viewDidLoad() {
        LabelUsername.text = CurrentUser.shared.user?.username
        LabelUsername.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tappedLabelUsername(_:))))
        NotificationCenter.default.addObserver(self, selector: #selector(dismiss(noti:)), name: Notification.Name(rawValue: "dismiss"), object: nil)
    }
    
    @objc func dismiss(noti: NSNotification){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func tappedLabelUsername(_ sender: Any){
        //show user profile here
        self.performSegue(withIdentifier: "user_profile", sender: self)
    }
    @IBAction func tappedCamera(_ sender: Any) {
        //open picker here. then if user picked an image, go to add post vc, else dismiss here
        let picker = YPImagePicker()
        picker.didFinishPicking { [unowned picker] items, cancelled in
            if cancelled{
                print("image picker cancelled")
                picker.dismiss(animated: true, completion: nil)
            }
            if let photo = items.singlePhoto {
                CurrentUser.shared.user!.tempImage = photo.image
                picker.dismiss(animated: false, completion: {
                    //show add post vc
                    self.performSegue(withIdentifier: "add_post", sender: self)
                })
            }
        }
        present(picker, animated: true, completion: nil)
    }
    @IBAction func tappedSearch(_ sender: Any) {
    }
    @IBAction func tappedDraw(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "user_profile":
            let destVC = segue.destination as! UserProfileVC
            destVC.show_user_id = CurrentUser.shared.user?.userID
            return
        default:
            return
        }
    }
}
