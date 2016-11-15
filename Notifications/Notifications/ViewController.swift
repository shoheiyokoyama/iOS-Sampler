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
    
    let userNotification  = UNUserNotificationCenter.current()
    let notificationIdentifier = "localNotification"

    override func viewDidLoad() {
        super.viewDidLoad()
        // First time only
        confirmAuthorization()
        configureUserNotification()
        addLocalNotification()
        
        /*
        updateUserNotificaton()
        removeUserNotification()
         */
    }
    
    private func configureUserNotification() {
        userNotification.delegate = self
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

// MARK: - Local Notification

extension ViewController {
    func addLocalNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Title"
        content.body  = "body"
        content.sound = .default()
        
        // not notify when App active
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "localNotification", content: content, trigger: trigger)
        userNotification.add(request)
    }
}

// MARK: - UNUserNotificationCenterDelegate -

extension ViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("User select notification in foreground")
    }
}

// MARK: - Update and Remove -

extension ViewController {
    func removeUserNotification() {
        userNotification.removeDeliveredNotifications(withIdentifiers: [notificationIdentifier])
    }
    
    func updateUserNotificaton() {
        let content = UNMutableNotificationContent()
        content.title = "New Title"
        content.body  = "New Body"
        content.sound = .default()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let request = UNNotificationRequest(identifier: notificationIdentifier, content: content, trigger: trigger)
        userNotification.add(request) { _ in }
    }
}

