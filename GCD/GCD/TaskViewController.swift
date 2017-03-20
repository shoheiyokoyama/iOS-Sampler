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
        test2()
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
 - POP
 - main
 - Qality of Service
 */

extension TaskViewController {
    func test() {
        TaskManager {
            print("Start")
        }.next { object, done in
            print("excute 1", object ?? "")
            done(1)
        }.next { object, done in
            print("excute 2", object ?? "")
            done(2)
        }.next { object, done in
            print("excute 3", object ?? "")
            done(3)
        }.run()
    }
    
    func test2() {
        SerialTask<String> { f, e in
            var error: TaskError?
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                if let error = error {
                    e(error)
                } else {
                    f("OK")
                }
            }
        }.map { okSt -> Int in
            print(okSt)
            return 1
        }.map { num1 -> Bool in
            print(num1)
            return false
        }.map { bool -> CGFloat in
            print(bool)
            return 0.2
        }
        .catchError { error in
            print(error)
        }
    }
    
    func serialTest() {
        /*
         Task {
         
        }.do {
         
        }.do {
         
        }
         */
    }
}
