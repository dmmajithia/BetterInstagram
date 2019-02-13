//
//  SetProfilePicture.swift
//  BetterInstagram
//
//  Created by Dhawal Majithia on 2/12/19.
//  Copyright © 2019 Dhawal Majithia. All rights reserved.
//

import UIKit
import YPImagePicker

class SetProfilePicture: UIViewController{
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var setButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func setTapped(_ sender: Any) {
        //open image picker
        self.doneButton.isHidden = true
        let picker = YPImagePicker()
        picker.didFinishPicking { [unowned picker] items, cancelled in
            if cancelled{
                print("image picker cancelled")
                return
            }
            if let photo = items.singlePhoto {
                /*print(photo.fromCamera) // Image source (camera or library)
                print(photo.image) // Final image selected by the user
                print(photo.originalImage) // original image selected by the user, unfiltered
                print(photo.modifiedImage) // Transformed image, can be nil
                print(photo.exifMeta) */// Print exif meta data of original image.
                self.profileImage.image = photo.image
                self.profileImage.layer.cornerRadius = self.profileImage.frame.width/2
                self.profileImage.layer.masksToBounds = false
                self.profileImage.clipsToBounds = true
                self.setButton.isHidden = true
                self.doneButton.isHidden = false
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func doneTaped(_ sender: Any){
        //upload picture, then segue to set_profile
        
        self.performSegue(withIdentifier: "set_profile", sender: self)
    }
    
}
