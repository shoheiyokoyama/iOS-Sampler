//
//  ViewController.swift
//  Today
//
//  Created by Shohei Yokoyama on 2016/12/19.
//  Copyright © 2016年 com.shoheiyokoyama. All rights reserved.
//

import UIKit
import NotificationCenter

class ViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    
    @IBAction func tappedButton(_ sender: Any) {
        let flg: Bool
        if button.titleLabel?.text == "Hide Widget" {
            flg = false
            button.setTitle("Show Widget", for: .normal)
        } else {
            flg = true
            button.setTitle("Hide Widget", for: .normal)
        }
        let widgetController = NCWidgetController()
        widgetController.setHasContent(flg, forWidgetWithBundleIdentifier: "shohei.Today.TodayExtension")
    }
}

