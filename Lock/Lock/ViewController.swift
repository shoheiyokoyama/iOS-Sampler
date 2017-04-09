//
//  ViewController.swift
//  Lock
//
//  Created by Shohei Yokoyama on 2017/04/09.
//  Copyright © 2017年 Shohei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var number = 0
    let loop = 10000

    override func viewDidLoad() {
        super.viewDidLoad()
        
        excuteOnSeparateThread { [weak self] in
            self?.number += 1
        }
        
        sleep(2)
        var result = check()
        // result is false
        print(result)
        
        clean()
        
        let lockQueue = DispatchQueue(label: "serialQueue")
        
        excuteOnSeparateThread {
            lockQueue.sync { [weak self] in
                self?.number += 1
            }
        }
        
        sleep(2)
        
        result = check()
        // result is true
        print(result)
        
        clean()
        
        let semaphore = DispatchSemaphore(value: 1)
        
        excuteOnSeparateThread { [weak self] in
            semaphore.wait()
            self?.number += 1
            semaphore.signal()
        }
        
        sleep(2)
        
        result = check()
        // result is true
        print(result)
        
        clean()
    }
    
    func check() -> Bool {
        return number == loop
    }
    
    func clean() {
        number = 0
    }
    
    func excuteOnSeparateThread(_ closure: @escaping () -> Void) {
        (0..<loop).forEach { _ in
            Thread.detachNewThread {
                closure()
            }
        }
    }
}


