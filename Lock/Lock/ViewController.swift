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
        
        //appendTest()
        //syncTest()
        //semaphoreTest()
        //nsLockTest()
        //nsLockErrorTest()
        nsRecursiveLockTest()
    }
    
    func check(expect: Int = 10000) -> Bool {
        return number == expect
    }
    
    func clean() {
        number = 0
    }
    
    func excuteOnSeparateThread(_ count: Int = 10000, closure: @escaping () -> Void) {
        (0..<count).forEach { _ in
            Thread.detachNewThread {
                closure()
            }
        }
    }
}

// test
extension ViewController {
    func appendTest() {
        defer { clean() }
        
        let count = 100000
        excuteOnSeparateThread(count) { [weak self] in
            self?.number += 1
        }
        
        sleep(1)
        let result = check(expect: count)
        // result is false
        print(result)
    }
    
    // MARK: - DispatchQueue sync
    func syncTest() {
        defer { clean() }
        
        let lockQueue = DispatchQueue(label: "serialQueue")
        excuteOnSeparateThread {
            lockQueue.sync { [weak self] in
                self?.number += 1
            }
        }
        
        sleep(1)
        
        let result = check()
        // result is true
        print(result)
    }
    
    // MARK: - DispatchSemaphore
    func semaphoreTest() {
        defer { clean() }
        
        let semaphore = DispatchSemaphore(value: 1)
        
        excuteOnSeparateThread { [weak self] in
            semaphore.wait()
            self?.number += 1
            semaphore.signal()
        }
        
        sleep(1)
        
        let result = check()
        // result is true
        print(result)
    }
    
    // MARK: - NSLock
    func nsLockTest() {
        defer { clean() }
        
        let nsLock = NSLock()
        excuteOnSeparateThread { [weak self] in
            nsLock.lock()
            self?.number += 1
            nsLock.unlock()
        }
        
        sleep(1)
        
        let result = check()
        // result is true
        print(result)
    }
    
    func nsLockErrorTest() {
        let lock = NSLock()
        
        var _number: Int = 3
        var number: Int {
            get {
                lock.lock(); defer { lock.unlock() }
                return _number
            }
            set {
                lock.lock(); defer { lock.unlock() }
                _number = newValue
            }
        }
        
        lock.lock()
        // Occur NSLockError because of recursive lock
        print(number)//*** -[NSLock lock]: deadlock (<NSLock: 0x6080000dabe0> '(null)') *** Break on _NSLockError() to debug
        lock.unlock()
    }
    
    // MARK: - NSRecursiveLock
    func nsRecursiveLockTest() {
        defer { clean() }
        
        let lock = NSRecursiveLock()
        excuteOnSeparateThread { [weak self] in
            lock.lock()
            self?.number += 1
            lock.unlock()
        }
        
        sleep(1)
        
        let result = check()
        // result is true
        print(result)
        
        clean()
        
        var _number: Int = 3
        var number: Int {
            get {
                lock.lock(); defer { lock.unlock() }
                return _number
            }
            set {
                lock.lock(); defer { lock.unlock() }
                _number = newValue
            }
        }
        
        
        lock.lock()
        // don't Occur NSLockError
        print(number)
        lock.unlock()
    }
}


