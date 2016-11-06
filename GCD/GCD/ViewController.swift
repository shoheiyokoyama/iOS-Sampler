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
 - [【iPhoneアプリ】これを使えるようにならないと「マルチスレッド」について　概要編](http://kassans.hatenablog.com/entry/2014/03/13/125332)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        excuteIterations()
        createQueue()
        createSystemQueue()
        excureAcyncAfter()
        groupExcute()
    }
}

// MARK: - Private Methods

private extension ViewController {
    
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
         */
        
        // Concurrent Queue
        DispatchQueue.global(qos: .default).async {
            print("global")
        }
    }
    
    func excureAcyncAfter() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(5)) {
            print("5 second after")
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
}

