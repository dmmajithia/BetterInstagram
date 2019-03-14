//
//  SHowWeb.swift
//  BetterInstagram
//
//  Created by Dhawal Majithia on 3/7/19.
//  Copyright © 2019 Dhawal Majithia. All rights reserved.
//

import UIKit
import WebKit

class ShowWeb: UIViewController{
    var url: String!
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        if(self.url != nil){
            self.webView.load(URLRequest(url: URL(string: self.url)!))
        }
    }
    @IBAction func canelTapped(_ sender: Any) {
        self.dismissMe()
    }
}
