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
    
    // UserNotificatonIdentifier
    struct UNI {
        static let local  = "localNotification"
        static let custom = "customUserNotification"
        static let category = "category-message"
        
        struct Action {
            static let replay = "replay-action"
            static let delete = "delete-action"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // First time only
        confirmAuthorization()
        configureUserNotification()
        
        //addLocalNotification()
        
        /*
        updateUserNotificaton()
        removeUserNotification()
         */
        
        registerCustomNotification()
        addCustomNotification()
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
        let request = UNNotificationRequest(identifier: UNI.local, content: content, trigger: trigger)
        userNotification.add(request)
    }
}

// MARK: - UNUserNotificationCenterDelegate -

extension ViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("User select notification in foreground")
        
        if response.actionIdentifier == UNI.Action.replay {
            print("Selected Reply Action")
        }
        if response.actionIdentifier == UNI.Action.delete {
            print("Selected Delete Action")
        }
        completionHandler()
    }
}

// MARK: - Update and Remove -

extension ViewController {
    func removeUserNotification() {
        userNotification.removeDeliveredNotifications(withIdentifiers: [UNI.local])
    }
    
    func updateUserNotificaton() {
        let content = UNMutableNotificationContent()
        content.title = "New Title"
        content.body  = "New Body"
        content.sound = .default()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let request = UNNotificationRequest(identifier: UNI.local, content: content, trigger: trigger)
        userNotification.add(request) { _ in }
    }
}

// MARK: - UNNotificationAction & Category

extension ViewController {
    func registerCustomNotification() {
        let replayAction = UNNotificationAction(identifier: UNI.Action.replay, title: "replay", options: [])
        let deleteAction = UNNotificationAction(identifier: UNI.Action.delete, title: "delete", options: [])
        
        let category = UNNotificationCategory(identifier: UNI.category, actions: [replayAction, deleteAction], intentIdentifiers: [], options: [])
        userNotification.setNotificationCategories([category])
    }
    
    func addCustomNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Custom Title"
        content.body  = "Custom body"
        content.sound = .default()
        
        content.categoryIdentifier = UNI.category
        
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UNI.custom, content: content, trigger: trigger)
        userNotification.add(request)
    }
}

