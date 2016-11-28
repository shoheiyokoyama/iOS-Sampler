//
//  ViewController.swift
//  GCD
//
//  Created by Shohei Yokoyama on 2016/11/05.
//  Copyright © 2016年 Shohei. All rights reserved.
//

import UIKit

// MARK: - Constsnts

fileprivate struct Constsnts {
    static let bundleIdentifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String ?? ""
}

// MARK: - ViewController

class ViewController: UIViewController {
    
    fileprivate let identifier = Constsnts.bundleIdentifier
    
    typealias CallBack = @convention(c) () -> Void
    
    lazy var once: Void = { self.excuteOnce() }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        workItemExample()
        groupExample()
        suspendExample()
        barrierExample()
        iterationsExample()
        createQueue()
        createSystemQueue()
        asyncAfterExample()
        callBackExample()
        workItemExample()
        addTask()
        
        semaphoreExample1()
        semaphoreExample2()
        semaphoreExample3()
        
        // excute just once
        _ = once
        _ = once
        _ = once
         */
    }
}

// MARK: - Excute with closure

extension ViewController {
    func callBackExample() {
        let closure: (DispatchQueue, @escaping CallBack) -> Void = { queue, callBack in
            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(3)) {
                queue.async(execute: callBack)
            }
        }
        
        let queue = DispatchQueue.global()
        
        closure(queue) {
            print("callback 3 second after")
        }
        
        queue.async {
            print("excute")
        }
    }
}

// MARK: - Excute only once

extension ViewController {
    func excuteOnce() {
        print("this method excute just once")
    }
}

// MARK: - async or sync

extension ViewController {
    func addTask() {
        DispatchQueue.global().async {
            sleep(1)
            print("Excute Task")
        }
        
        print("Qiita")
    }
}

// MARK: - Create queue

extension ViewController {
    func createQueue() {
        // Serial Queue
        DispatchQueue(label: identifier + "serialQueue").async {
            print("do sub thread")
        }
        
        // Concurrent Queue
        DispatchQueue(label: identifier + "concurrentQueue", attributes: .concurrent).async {
            print("do sub thread")
        }
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
}

// MARK: - asyncAfter

extension ViewController {
    /*
     
     enum DispatchTimeInterval {
     case seconds(Int)
     case milliseconds(Int)
     case microseconds(Int)
     case nanoseconds(Int)
     }
     */
    
    func asyncAfterExample() {
        let after = 5
        _ = DispatchTime.now() + 3 // ok
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(after)) {
            print("excute \(after) second after")
        }
    }
}

// MARK: - DispatchGroup

extension ViewController {
    func groupExample() {
        let group  = DispatchGroup()
        
        // Serial queue
        let queue1 = DispatchQueue(label: identifier + ".queue1")
        let queue2 = DispatchQueue(label: identifier + ".queue2")
        let queue3 = DispatchQueue(label: identifier + ".queue3")
        
        // these task is concurrent because defference queue
        queue1.async(group: group) {
            print("start queue1")
            sleep(4)
            print("end queue1")
        }
        
        queue2.async(group: group) {
            print("start queue2")
            sleep(2)
            print("end queue2")
        }
        
        queue3.async(group: group) {
            print("start queue3")
            sleep(1)
            print("end queue3")
        }
        
        
        group.notify(queue: DispatchQueue.main) {
            print("All task Done")
        }
    }
}

// MARK: - Iterations

extension ViewController {
    func iterationsExample() {
        
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

// MARK: - barrier flag

extension ViewController {
    func barrierExample() {
        // NOTE: barrier available private concurrent queue only??.
        let queue = DispatchQueue(label: "com.sample.barrier", attributes: .concurrent)
        
        (0...100).forEach { index in
            
            // index of 30~50 is secured as serial task
            if 30...50 ~= index {
                queue.async(flags: .barrier) {
                    print("excute index: \(index) task as barrier")
                }
            } else {
                queue.async {
                    print("excute index: \(index) task as concurrent")
                }
            }
        }
    }
}

// MARK: - Queue suepend

extension ViewController {
    func suspendExample() {
        // NOTE: suspend() available private queue only.
        
        let queue = DispatchQueue(label: identifier + ".concurrentQueue")
        
        queue.suspend()
        
        var number = 30
        
        // Second, this output as log
        (0...10).forEach { index in queue.async { print("number: \(number)") } }
        
        sleep(1)
        
        number = 10
        
        // First, this output as log
        print("change number to 10")
        
        // excute added closure
        queue.resume()
    }
}

// MARK: - DispatchWorkItem

extension ViewController {
    func workItemExample() {
        let workItem = DispatchWorkItem {
            (0...5).forEach { index in
                sleep(1)
                print("index: \(index)")
            }
        }
        
        // excute without queue
        workItem.perform()
        
        // excute with queue
        //DispatchQueue.global().async(execute: workItem)
    }
}

// MARK: - DispatchSemaphore

extension ViewController {
    
    /*
     DispatchSemaphore(value: 2)
     
     value: initial count
     
     semaphone.wait()   decrement count
     semaphone.signal() increment count
     */
    
    // excute only 2 task at a time.
    func semaphoreExample1() {
        let semaphone = DispatchSemaphore(value: 2)
        let queue = DispatchQueue.global()
        
        (0...10).forEach { index in
            queue.async {
                semaphone.wait()
                print("Excute sleep: \(index)")
                sleep(2)
                print("End sleep: \(index)")
                semaphone.signal()
            }
        }
    }
    
    // Wait task complete
    func semaphoreExample2() {
        let semaphone = DispatchSemaphore(value: 0)
        let queue = DispatchQueue.global()
        
        queue.async {
            print("Excute sleep")
            sleep(2)
            print("End sleep")
            
            semaphone.signal()
        }
        
        print("Wait task")
        semaphone.wait()
        print("Task finished")
    }
    
    // Wait muiltiple task complete
    func semaphoreExample3() {
        let semaphone = DispatchSemaphore(value: 0)
        let queue = DispatchQueue.global()
        
        let i = 5
        (0...i).forEach { index in
            queue.async {
                print("Excute sleep: \(index)")
                sleep(2)
                print("End sleep: \(index)")
                
                semaphone.signal()
            }
        }
        
        (0...i).forEach { index in
            semaphone.wait()
            print("Complete: \(index)")
        }
        
        print("All task finished")
    }
}

