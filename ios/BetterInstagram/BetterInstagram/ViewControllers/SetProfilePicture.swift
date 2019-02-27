//
//  SetProfilePicture.swift
//  BetterInstagram
//
//  Created by Dhawal Majithia on 2/12/19.
//  Copyright © 2019 Dhawal Majithia. All rights reserved.
//

// WORKFLOW -
// When view loads - show "photo add" button, hide next button
// When photo selected - show photo, hide "photo add" button, show next button, add tap recognizer on selected to select a different photo

import UIKit
import YPImagePicker
import VBFPopFlatButton
import LTMorphingLabel

class SetProfilePicture: UIViewController{
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var greetLabel: LTMorphingLabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var successLabel: LTMorphingLabel!
    
    var nextButton: VBFPopFlatButton!
    var addPhotoButton: VBFPopFlatButton!
    var photoAdded: Bool!
    var photoTap: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.photoAdded = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //update
        self.greetLabel.text = ""
        self.greetLabel.text = (CurrentUser.shared.user?.username)! + ", set a profile picture"
        
        //create next button
        self.nextButton = VBFPopFlatButton(frame: self.doneButton.frame, buttonType: .buttonForwardType, buttonStyle: .buttonRoundedStyle, animateToInitialState: true)
        nextButton?.roundBackgroundColor = UIColor.white
        nextButton?.lineThickness = 2
        nextButton?.tintColor = self.view.backgroundColor
        nextButton?.addTarget(self, action: #selector(self.doneTapped(_:)), for: .touchUpInside)
        self.view.addSubview(self.nextButton)
        self.hideView(view: self.nextButton as UIView)
        self.doneButton.isHidden = true
        
        //create addPhoto button
        let height = self.nextButton.frame.height
        let width = self.nextButton.frame.width
        let addPhotoFrame = CGRect(x: (self.view.frame.width-width)/2, y: (self.view.frame.height-height)/2, width: width, height: height)
        self.addPhotoButton = VBFPopFlatButton(frame: addPhotoFrame, buttonType: .buttonAddType, buttonStyle: .buttonRoundedStyle, animateToInitialState: true)
        addPhotoButton?.roundBackgroundColor = UIColor.white
        addPhotoButton?.lineThickness = 2
        addPhotoButton?.tintColor = self.view.backgroundColor
        addPhotoButton?.addTarget(self, action: #selector(self.setTapped(_:)), for: .touchUpInside)
        self.view.addSubview(self.addPhotoButton)
        self.showView(view: self.addPhotoButton)
        
        //add tap recognizer to profile picture
        self.photoTap = UITapGestureRecognizer(target: self, action: #selector(self.setTapped(_:)))
        self.profileImage.addGestureRecognizer(photoTap)
        
        //edit profileImage view. add border width, colour, boujee
        //self.profileImage.layer.borderColor = UIColor.white.cgColor
        //self.profileImage.layer.borderWidth = 2.0
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width/2
    }
    
    @IBAction func setTapped(_ sender: Any) {
        //open image picker
        self.hideView(view: self.addPhotoButton)
        self.hideView(view: self.nextButton)
        let picker = YPImagePicker()
        picker.didFinishPicking { [unowned picker] items, cancelled in
            if cancelled{
                print("image picker cancelled")
            }
            if let photo = items.singlePhoto {
                self.profileImage.image = photo.image
                self.profileImage.layer.masksToBounds = false
                self.profileImage.clipsToBounds = true
                self.photoAdded = true
            }
            picker.dismiss(animated: true, completion: {
                self.updateViews()
            })
        }
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func doneTapped(_ sender: Any){
        //upload picture, then segue to set_profile
        //let setProfileVC = SetProfileVC()
        //self.navigationController?.pushViewController(SetProfileVC(), animated: true)
        /*Api.uploadImage(image: self.profileImage.image!, completion: {json in
            
        })*/
        /*self.photoTap.isEnabled = false
        self.nextButton.isEnabled = false
        self.addPhotoButton.isEnabled = false*/
        
        ////
        
        CurrentUser.setProfilePicture(image: self.profileImage.image!, completion: {
            
            self.performSegue(withIdentifier: "set_profile", sender: self)
        })
    }
    
    func updateViews(){
        if(self.photoAdded){
            self.showView(view: self.nextButton)
            self.hideView(view: self.addPhotoButton)
            //self.profileImage.isHidden = false
            self.successLabel.text = "🔥🔥"
        }
        else{
            self.showView(view: self.addPhotoButton)
            self.hideView(view: self.nextButton)
            //self.profileImage.isHidden = true
            //self.successLabel.text = ""
        }
    }
    
    func showView(view: UIView){
        view.isHidden = false
    }
    
    func hideView(view: UIView){
        view.isHidden = true
    }
    
}
