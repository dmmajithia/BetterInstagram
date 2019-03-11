//
//  AddPostVC.swift
//  BetterInstagram
//
//  Created by Dhawal Majithia on 2/26/19.
//  Copyright © 2019 Dhawal Majithia. All rights reserved.
//

import UIKit
import VBFPopFlatButton
import YPImagePicker
//import MZLocationPicker
//import LocationPicker

class AddPostVC: UIViewController, UITextViewDelegate{
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var addLocationButton: UIButton!
    
    var loactionCoords = ""
    var locationName = ""
    
    override func viewDidLoad() {
        self.postImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tappedPhoto(_sender:))))
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.postImageView.image = CurrentUser.shared.user?.tempImage
        self.postImageView.layer.cornerRadius = 0.25
        captionTextView.delegate = self
    }
    
    @objc func tappedPhoto(_sender: Any){
        //show image picker
        let picker = YPImagePicker()
        picker.didFinishPicking { [unowned picker] items, cancelled in
            if cancelled{
                print("image picker cancelled")
            }
            if let photo = items.singlePhoto {
                self.postImageView.image = photo.image
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func tappedAddLocation(_ sender: Any) {
        /*let locationPicker = LocationPickerViewController()
        locationPicker.currentLocationButtonBackground = self.view.backgroundColor!
        locationPicker.mapType = .standard
        locationPicker.useCurrentLocationAsHint = true
        locationPicker.searchBarPlaceholder = "Add Location"
        locationPicker.completion = {location in
            
        }
        self.present(locationPicker, animated: false, completion: nil)*/
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Add Location", message: "", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = "enter here"
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            if(!(alert?.textFields![0].text!.isEmpty)!){
                self.locationName = (alert?.textFields![0].text)!
                self.addLocationButton.text(self.locationName)
            }
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func tappedShare(_ sender: Any) {
        Api.addPost(image: self.postImageView.image!, caption: self.captionTextView.text, location: self.locationName, completion: {(json) -> () in
            print(json)
            self.dismissMe()
        })
    }
    @IBAction func tappedCancel(_ sender: Any) {
        dismissMe()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        /*textView.text = String(textView.text.prefix(200))
        if(textView.text.isEmpty){
            textView.text = "Write a caption..."
        }*/
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if(textView.text == "Write a caption..."){
            textView.text = ""
        }
        return true
    }
    
//    func dismissMe(){
//        NotificationCenter.default.post(name: Notification.Name(rawValue: "dismiss"), object: nil)
//    }
    
}
