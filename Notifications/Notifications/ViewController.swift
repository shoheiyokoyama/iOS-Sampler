//
//  ViewController.swift
//  Notifications
//
//  Created by Shohei Yokoyama on 2016/11/14.
//  Copyright © 2016年 Shohei Yokoyama. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        confirmAuthorization()
    }
}

// MARK: - Authorization

private extension ViewController {
    func confirmAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            granted, error in
            if let error = error {
                print(error)
                return
            }
            
            // Register notification
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
}

