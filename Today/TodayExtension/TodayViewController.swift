//
//  TodayViewController.swift
//  TodayExtension
//
//  Created by Shohei Yokoyama on 2016/12/19.
//  Copyright © 2016年 com.shoheiyokoyama. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet weak var button: UIButton! {
        didSet { button.layer.cornerRadius = 5 }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { [weak self] context in
            self?.textLabel.alpha = 0.3
            self?.imageView.alpha = 0.3
        }, completion: { [weak self] _ in
            self?.textLabel.alpha = 1
            self?.imageView.alpha = 1
        })
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

//        fethTodayData() { data, error in
//            guard let _ = error else { completionHandler(.failed) }
//            updateUI()
//            completionHandler(.newData)
//        }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd hh:mm:ss"
        textLabel.text = "Now: " + formatter.string(from: Date())
        completionHandler(.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if case .compact = activeDisplayMode {
            self.preferredContentSize = maxSize
        } else {
            self.preferredContentSize.height = 250
        }
    }
    
    @IBAction func tappedButton(_ sender: Any) {
        let url = URL(string: "todaySample://")
        extensionContext?.open(url!, completionHandler: nil)
    }
}
