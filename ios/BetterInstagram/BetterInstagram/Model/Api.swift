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
//import FacebookCore

struct Api{
    
    static let API_ENDPOINT = "http://52.32.0.100/"
    static let appID = UIDevice.current.identifierForVendor!.uuidString
    
    static func makeRequest(endpoint: String, data: [String:String], completion: @escaping (JSON) -> ()){
        var URL = API_ENDPOINT + endpoint
        var parameters = 0
        for (key, value) in data{
            URL += (parameters==0 ? "?" : "&") + key + "=" + value
            parameters += 1
        }
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

    
 
    
}
