 //
//  WebVC.swift
//  FoodPin
//
//  Created by 贝蒂小熊 on 2021/12/25.
//

import UIKit
import WebKit

class WebVC: UIViewController {
    
    @IBOutlet var webView: WKWebView!
    
    var targetURL = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL(string: targetURL) {
            let request = URLRequest(url: url)
            webView.load(request)
        }

    }
    
    
}
