//
//  AppDelegate.swift
//  BetterInstagram
//
//  Created by Dhawal Majithia on 1/26/19.
//  Copyright © 2019 Dhawal Majithia. All rights reserved.
//

import UIKit
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var currentParent: UIViewController!
    //var currentUser: User?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        NotificationCenter.default.addObserver(self, selector: #selector(self.setParent(noti:)), name: Notification.Name(rawValue: "SetParent"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.dismissCurrentVC(noti:)), name: Notification.Name(rawValue: "DismissCurrentVC"), object: nil)
        
        // first get appID from CloudKit
        Api.login(completion: {(json) -> () in
            if(json["success"].bool!){
                CurrentUser.shared.user?.json(json: json)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "MainTab")
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
            }
            else{
                self.segueToSignup()
            }
        })
        return true
    }
    
    func segueToSignup(){
        //segue to login storyboard
        NSLog("segue to signup")
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Signup", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "signupNVC")
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }
    
    /// async gets iCloud record ID object of logged-in iCloud user
    func iCloudUserIDAsync(complete: @escaping (_ instance: CKRecord.ID?, _ error: NSError?) -> ()) {
        let container = CKContainer.default()
        container.fetchUserRecordID() {
            recordID, error in
            if error != nil {
                print(error!.localizedDescription)
                complete(nil, error! as NSError)
            } else {
                print("fetched ID \(String(describing: recordID?.recordName))")
                complete(recordID, nil)
            }
        }
    }
    
    @objc func setParent(noti: Notification){
        self.currentParent = (noti.object as! UIViewController)
    }
    
    @objc func dismissCurrentVC(noti: Notification){
        self.currentParent.dismiss(animated: true, completion: nil)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    /*func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = SDKApplicationDelegate.shared.application(app, open: url, options: options)
        return handled
    }*/


}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func dismissMe(){
        NotificationCenter.default.post(name: Notification.Name(rawValue: "DismissCurrentVC"), object: nil)
    }
}

extension UIImageView {
    func setCornerRadius(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = false
        self.clipsToBounds = true
    }
}

