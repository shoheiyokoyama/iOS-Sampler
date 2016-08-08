//
//  DataViewController.swift
//  PageViewController
//
//  Created by 横山祥平 on 2016/08/08.
//  Copyright © 2016年 Shohei. All rights reserved.
//

import UIKit

final class MyDataViewController: UIViewController, Pageable {

    var identifiers: [String] = ["MyDataView.First", "MyDataView.Second"]
    var identifier: String?
    var items: [Int]?
    
    class func instantiate() -> MyDataViewController {
        let instance = MyDataViewController()
        instance.identifier = instance.identifiers.first
        return instance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
