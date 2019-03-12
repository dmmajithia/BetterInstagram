//
//  Api.swift
//  BetterInstagram
//
//  Created by Dhawal Majithia on 1/28/19.
//  Copyright © 2019 Dhawal Majithia. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import CloudKit
//import FacebookCore

struct Api{
    
    static let API_ENDPOINT = "http://52.32.0.100/"
    static let appID = UIDevice.current.identifierForVendor!.uuidString
    static let imageCache = NSCache<AnyObject, AnyObject>()
    static var posts = [String:JSON]() // [postID:postJSON]
    static var users = [String:JSON]() // [userID:userJSON]
    
    //// Base function for building and sending a request
    static func makeRequest(endpoint: String, data: [String:String], completion: @escaping (JSON) -> ()){
        var URL = API_ENDPOINT + endpoint
        var parameters = 0
        for (key, value) in data{
            URL += (parameters==0 ? "?" : "&") + key + "=" + value
            parameters += 1
        }
        print(URL)
        AF.request(URL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                   method: .get).validate().responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        print(json)
                        completion(json)
                    case .failure(let error):
                        print(error)
                    }
            }
    }
    
    //// Login with current iCloud account
    static func login(completion: @escaping (JSON) -> ()){
        Api.getAppID(completion: {(appID, error) -> () in
            if(error == nil){
                Api.makeRequest(endpoint: "login/login", data: ["appID": appID], completion: completion)
            }
        })
    }

    //// Check if a username already exists. Returns json array with one key - "existed" -> Bool
    static func checkUsername(username: String, completion: @escaping (JSON) -> ()){
        Api.makeRequest(endpoint: "login/check_username", data: ["username": username], completion: completion)
    }
    
    //// Signup user with given username and current iCloud account
    static func signup(username: String, completion: @escaping (JSON) -> ()){
        Api.getAppID(completion: {(appID, error) -> () in
            if(error == nil){
                Api.makeRequest(endpoint: "login/signup", data: ["appID": appID, "username": username], completion: completion)
            }
        })
    }
    
    static func setProfilePictureUrl(url: String, completion: @escaping ()->()){
        Api.makeRequest(endpoint: "profile/set_profile_picture", data: ["user_id": (CurrentUser.shared.user?.userID)!,
                                                                "file_name": url], completion: {(json) -> () in
                                                                    if(json["success"].bool!){
                                                                        completion()
                                                                    }
        })
    }
    
    static func getUserProfileJson(userID: String, completion: @escaping (JSON) -> ()){
        if let cachedUserJSON = self.users[userID]{
            completion(cachedUserJSON)
            return
        }
        Api.makeRequest(endpoint: "profile/get_profile_data", data: ["user_id2": userID, "user_id": (CurrentUser.shared.user?.userID)!], completion: {(json) -> () in
            self.users[userID] = json
            completion(json)
        })
    }
    
    static func addPost(image: UIImage, caption: String, location: String, completion: @escaping (JSON)->()){
        Api.uploadImage(image: image, completion: {(json) -> () in
            if(json["success"].bool!){
                let url = json["file_name"].string!
                var data = ["caption":caption]
                data["file_url"] = url
                data["timestamp"] = String(Date().timeIntervalSince1970)
                data["location"] = location
                //data["hashtags"] = ""
                //data["tags"] = ""
                data["user_id"] = CurrentUser.shared.user?.userID
                //data["mood"] = ""
                Api.makeRequest(endpoint: "post/add_post", data: data, completion: {(json) -> () in
                    completion(json)
                })
            }
        })
    }
    
    static func getImage(url: String, userID: String, completion: @escaping (UIImage) -> ()){
        let imageUrl = API_ENDPOINT + "static/" + userID + "/" + url
        if let image = imageCache.object(forKey: imageUrl as AnyObject) as? UIImage{
            completion(image)
            return
        }
        AF.download(imageUrl).responseData { response in
            if let data = response.result.value {
                let image = UIImage(data: data)
                imageCache.setObject(image!, forKey: imageUrl as AnyObject)
                completion(image!)
            }
        }
    }
    
    static func searchUsername(text: String, completion: @escaping ([JSON]) -> ()){
        Api.makeRequest(endpoint: "search/search_name", data: ["username": text], completion: {(json) -> () in
            if(json["success"].bool!){
                completion(json["users"].array!)
            }
        })
    }
    
    static func getPostData(postID: String, completion: @escaping (JSON) -> ()){
        if let cachedPostJSON = self.posts[postID]{
            completion(cachedPostJSON)
            return
        }
        Api.makeRequest(endpoint: "post/get_post_data", data: ["post_id": postID], completion: {(json) -> () in
            self.posts[postID] = json
            completion(json)
        })
    }
    
    static func getPosts(userID: String, completion: @escaping ([Int]) -> ()){
        Api.makeRequest(endpoint: "post/get_posts", data: ["user_id":userID, "last_post_id": "9999999"], completion: {(json) -> () in
            if(json["success"].bool!){
                let postIDs = json["post_id"].arrayObject as! [Int]
                completion(postIDs)
            }
        })
    }
    
    static func getActivityFeed(userID: String, completion: @escaping ([Int]) -> ()){
        Api.makeRequest(endpoint: "feed/get_activity_feed", data: ["user_id":userID, "last_post_id": "9999999"], completion: {(json) -> () in
            if(json["success"].bool!){
                let postIDs = json["post_id"].arrayObject as! [Int]
                completion(postIDs)
            }
        })
    }
    
    //// Upload given image to webserver. Returns json with 
    static func uploadImage(image: UIImage, completion: @escaping (JSON) -> ()){
        let URL = API_ENDPOINT + "profile/upload_picture?user_id=" + (CurrentUser.shared.user?.userID)!
        let imageData = Data(image.jpegData(compressionQuality: 0.5)!)
        AF.upload(multipartFormData: {MultipartFormData in
            MultipartFormData.append(imageData, withName: "file", fileName: "file.jpg", mimeType: "image/jpg")
        }, to: URL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!).validate().responseJSON(completionHandler: {response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                completion(json)
            case .failure(let error):
                //print(JSON(response.result.value!))
                print(error)
            }
        })
    }
    
    static func getAppID(completion: @escaping (String, Error?) -> ()){
        //completion("123456", nil)
        //return
        let container = CKContainer.default()
        container.fetchUserRecordID() {
            recordID, error in
            if error != nil {
                print(error!.localizedDescription)
                completion("", error! as NSError)
            } else {
                print("fetched ID \(String(describing: recordID?.recordName))")
                completion((recordID?.recordName)!, nil)
            }
        }
    }
 
    
}
