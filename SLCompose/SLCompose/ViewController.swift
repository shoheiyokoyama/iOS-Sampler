//
//  ViewController.swift
//  SLCompose
//
//  Created by 横山 祥平 on 2016/11/28.
//  Copyright © 2016年 Abema TV, Inc. All rights reserved.
//

import UIKit
import Social

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func tap(_ sender: Any) {
        guard let v = SLComposeViewController(forServiceType: SLServiceTypeTwitter) else {
            return
        }
        v.setInitialText("Initial Text")
        if let url = URL(string: "https://abema.tv/channels/yokonori-sports/slots/8TW7VCJN8ocik7?utm_source=social&utm_medium=social&utm_campaign=slot_share") {
            v.add(url)
        }
        UIApplication.forefrontViewController.present(v, animated: true, completion: nil)
    }
}

extension UIApplication {
    class var rootViewController: UIViewController {
        return (shared.delegate?.window??.rootViewController)!
    }
    
    class var forefrontViewController: UIViewController {
        var forefrontVC = UIApplication.rootViewController
        while let presentedVC = forefrontVC.presentedViewController {
            forefrontVC = presentedVC
        }
        return forefrontVC
    }
}

