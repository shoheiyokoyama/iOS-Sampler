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
        //test2()
        test3()
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
        SerialTask<String> { fullfill, error in
            var e: TaskError?
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                if let e = e {
                    error(e)
                } else {
                    fullfill("OK")
                }
            }
        }.fmap { st -> Int in
            print(st)
            return 1
        }.do {
            print("do")
        }.fmap { num -> Bool in
            print(num)
            return false
        }.fmap { bool -> CGFloat in
            print(bool)
            return 0.2
        }
        .catchError { error in
            print(error)
        }
    }
    
    func test3() {
        SerialTask<String> { fullfill, error in
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                    fullfill("OK")
                }
            }.fmap { st -> Int in
                print(st)
                return 1
            }.do {
                print("do")
            }
            .convertToConcurrent()
            .do {
                print("do1")
            }
            .do {
                print("do2")
            }
            .do {
                print("do3")
            }
    }
}
