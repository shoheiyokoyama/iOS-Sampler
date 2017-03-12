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
        
        ConcurrentTask<String> { f, e in
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                f("OK")
            }
        }.next { okSt -> Int in
            print(okSt!)
            return 1
        }
        .next { num1 -> Bool in
            print(num1!)
            return false
        }
        .next { bool -> CGFloat in
            print(bool!)
            return 0.2
        }
        .next { float -> Bool in
            print(float!)
            return false
        }
        
    }
}
