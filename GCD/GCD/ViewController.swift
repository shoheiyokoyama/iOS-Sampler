//
//  ViewController.swift
//  GCD
//
//  Created by Shohei Yokoyama on 2016/11/05.
//  Copyright © 2016年 Shohei. All rights reserved.
//

import UIKit

/*
 - [Swift GCD入門](http://qiita.com/ShoichiKuraoka/items/bb2a280688d29de3ff18)
 - [Swift3のGCD周りのまとめ](http://qiita.com/marty-suzuki/items/f0547e40dc09e790328f)
 - [並列プログラミングガイド](https://developer.apple.com/jp/documentation/ConcurrencyProgrammingGuide.pdf)
 - [Concurrent Programming With GCD in Swift 3](https://developer.apple.com/videos/play/wwdc2016/720/)
 - ※[【iPhoneアプリ】これを使えるようにならないと「マルチスレッド」について　概要編](http://kassans.hatenablog.com/entry/2014/03/13/125332)
 - [GCD のディスパッチセマフォを活用する (Objective-C〜Swift 3 対応)](https://blog.ymyzk.com/2015/08/gcd-grand-central-dispatch-semaphore/)
 - [[Swift 3] Swift 3時代のGCDの基本的な使い方](http://dev.classmethod.jp/smartphone/iphone/swift-3-how-to-use-gcd-api-1/)
 */

// MARK: - Constsnts

fileprivate struct Constsnts {
    static let bundleIdentifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String ?? ""
}

// MARK: - ViewController

class ViewController: UIViewController {
    
    fileprivate let identifier = Constsnts.bundleIdentifier
    
    lazy var once: Void = { self.excuteOnce() }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
/*
        excuteWithSuspend()
        excuteConcurrentTaskWithBarrier()
        excuteIterations()
        createQueue()
        createSystemQueue()
        excureAcyncAfter()
        groupExcute()
        
        // excute just once
        _ = once
        _ = once
        _ = once
 */
        //semaphoreExample1()
        //semaphoreExample2()
        semaphoreExample3()
    }
}

// MARK: - Private Methods

private extension ViewController {
    
    func excuteOnce() {
        print("this method excute just once")
    }
    
    func createQueue() {
        // Serial Queue
        DispatchQueue(label: identifier + "serialQueue").async {
            print("do sub thread")
        }
        
        // Concurrent Queue
        let _ = DispatchQueue(label: identifier + "concurrentQueue", attributes: .concurrent)
    }
    
    func createSystemQueue() {
        // Serial Queue
        DispatchQueue.main.async {
            print("main")
        }
        
        /*
         - userInteractive
         - userInitiated
         - default
         - utility
         - unspecified
         
         
         The lower priority, the more concurrent I guess ..
         */
        
        // Concurrent Queue
        DispatchQueue.global(qos: .default).async {
            print("global")
        }
        // qos default value is .default. so bellow same
        //DispatchQueue.global().async { }
    }
    
    func excureAcyncAfter() {
        
        /*
         
         enum DispatchTimeInterval {
            case seconds(Int)
            case milliseconds(Int)
            case microseconds(Int)
            case nanoseconds(Int)
         }
        */
        let after = 5
        _ = DispatchTime.now() + 3 // ok
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(after)) {
            print("excute \(after) second after")
        }
    }
    
    func groupExcute() {
        let group  = DispatchGroup()
        let queue1 = DispatchQueue(label: identifier + ".queue1")
        let queue2 = DispatchQueue(label: identifier + ".queue2")
        let queue3 = DispatchQueue(label: identifier + ".queue3")
        
        queue1.async(group: group) {
            sleep(4)
            print("excute queue1")
        }
        
        queue2.async(group: group) {
            sleep(2)
            print("excute queue2")
        }
        
        queue3.async(group: group) {
            sleep(1)
            print("excute queue3")
        }
        
        group.notify(queue: DispatchQueue.main) {
            print("All task Done")
        }
    }
    
    func workItemQueue() {
        let workItem = DispatchWorkItem {
            print("work item")
        }
        workItem.perform()
        workItem.wait()
        workItem.cancel()
    }
    
    func excuteIterations() {
        
        // Concurrent Queue
        DispatchQueue.concurrentPerform(iterations: 10) { index in
            sleep(2)
            print("\(index): concurrent excute")
        }
 
        // Excute Serial
        let queue = DispatchQueue(label: identifier + ".serialQueue")
        (0...10).forEach { index in
            // Not serial
            // let queue = DispatchQueue(label: identifier + ".queue" + ".\(index)")
            
            queue.async {
                sleep(UInt32(0.5))
                print("\(index): serial excute")
            }
        }
    }
    
    func excuteConcurrentTaskWithBarrier() {
        
        // grobal is concurrent Queue
        let queue: DispatchQueue = .global(qos: .background)
        
        (0...100).forEach { index in
            
            let closure: () -> ()
            
            // index of 30~50 is secured as serial task
            if 30...50 ~= index {
                closure = { print("excute index: \(index) task as barrier") }
            } else {
                closure = { print("excute index: \(index) task as concurrent") }
            }
            
            queue.async(execute: closure)
        }
    }
    
    func excuteWithSuspend() {
        
        // NOTE: suspend() available private queue only.
        
        let queue = DispatchQueue(label: identifier + ".concurrentQueue")
        
        queue.suspend()
        
        var number = 30
        
        // Second, this output as log
        (0...100).forEach { index in queue.async { print("number: \(number)") } }
        
        number = 10
        
        // First, this output as log
        print("change number to 10")
        
        // excute added closure
        queue.resume()
    }
}

// MARK: - DispatchSemaphore

extension ViewController {
    func semaphoreExample1() {
        
        // excute 2 task at a time.
        let semaphone = DispatchSemaphore(value: 2)
        let queue = DispatchQueue.global()
        
        (0...10).forEach { index in
            queue.async {
                semaphone.wait() //decrement
                print("Excute sleep: \(index)")
                sleep(2)
                print("end sleep: \(index)")
                semaphone.signal() //increment
            }
        }
    }
    
    // wait task complete
    func semaphoreExample2() {
        let semaphone = DispatchSemaphore(value: 0)
        let queue = DispatchQueue.global()
        
        queue.async {
            print("Excute sleep")
            sleep(2)
            print("end sleep")
            
            semaphone.signal() //increment
        }
        
        print("wait")
        semaphone.wait() //decrement
        print("task finished")
    }
    
    // wait muiltiple task complete
    func semaphoreExample3() {
        let semaphone = DispatchSemaphore(value: 0)
        let queue = DispatchQueue.global()
        
        let i = 5
        (0...i).forEach { index in
            queue.async {
                print("Excute sleep: \(index)")
                sleep(2)
                print("end sleep: \(index)")
                
                semaphone.signal() //increment
            }
        }
        
        (0...i).forEach { index in
            semaphone.wait() //decrement
            print("complete: \(index)")
        }
        
        print("finish all task")
    }
}

