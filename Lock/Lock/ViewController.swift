//
//  ViewController.swift
//  Lock
//
//  Created by Shohei Yokoyama on 2017/04/09.
//  Copyright © 2017年 Shohei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let lockQueue = DispatchQueue(label: "serialQueue")
    var numbers: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - sync
        (0..<1000).forEach { index in
            lockQueue.sync {
                numbers.append(index)
            }
        }
        
        sleep(1)
        
        var result = check()
        // result is true
        print(result)
        
        (0..<1000).forEach { index in
            numbers.append(index)
        }
        
        sleep(1)
        
        result = check()
        // result is false
        print(result)
    }
    
    func check() -> Bool {
        var result = true
        numbers.enumerated().forEach { index, num in
            if num != index {
                result = false
            }
        }
        return result
    }
}


