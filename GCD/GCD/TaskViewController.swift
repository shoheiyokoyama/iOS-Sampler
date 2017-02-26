//
//  TaskViewController.swift
//  GCD
//
//  Created by Shohei Yokoyama on 2016/11/19.
//  Copyright © 2016年 Shohei. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        test()
    }
}

/*
 - Rx like
 - promise
 - loop
 - change thread
 - condition
 - filter, map, zip...
 - error handling
 */

extension TaskViewController {
    func test() {
        TaskManager {
            print("Start")
        }.next { object, done in
            print("excute 1", object)
            done(1)
        }.next { object, done in
            print("excute 2", object)
            done(2)
        }.next { object, done in
            print("excute 3", object)
            done(3)
        }.run()
    }
}
