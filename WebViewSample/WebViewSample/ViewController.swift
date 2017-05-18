//
//  ViewController.swift
//  WebViewSample
//
//  Created by 横山 祥平 on 2017/05/18.
//  Copyright © 2017年 InstagramTeam12. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    let webView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.frame = self.view.bounds
        view.addSubview(webView)
        
        let url = URL(string:"https://github.com/")!
        var req = URLRequest(url: url)
        webView.load(req)
    }
}

