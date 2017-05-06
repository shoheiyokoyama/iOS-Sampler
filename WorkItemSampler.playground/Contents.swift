//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

// Concurrent Programming With GCD in Swift 3
// https://developer.apple.com/videos/play/wwdc2016/720/

func testWorkItemPerform() {
    let workItem = DispatchWorkItem {
        sleep(5)
        print("done")
    }
    
    workItem.perform() // Execute synchronously
    print("after perfrom") // perform after work finished.
}

// - dispatch_block_wait(dispatch_block_t block, dispatch_time_t timeout);
// https://github.com/apple/swift-corelibs-libdispatch/blob/master/dispatch/block.h#L278-L327
func testWorkItemWait() {
    let queue = DispatchQueue(label: "queue", attributes: .concurrent)
    let workItem = DispatchWorkItem {
        sleep(3)
        print("done")
    }
    
    queue.async(execute: workItem)
    print("before waiting")
    workItem.wait()
    print("after waiting") // perform after work finished.
}

func testWorkItemCancel() {
    let queue = DispatchQueue(label: "queue", attributes: .concurrent)
    let workItem = DispatchWorkItem {
        print("done")
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
        queue.async(execute: workItem)
    }
    
    // Enabled to suspend a task has not been executed yet
    // But running task cannot be interrupted
    workItem.cancel()
}


func testWorkItemWaitTimeOut() {
    let queue = DispatchQueue(label: "queue", attributes: .concurrent)
    let workItem = DispatchWorkItem {
        sleep(3)
        print("done")
    }
   
    queue.async(execute: workItem)
    print("before waiting")
    
    // If task isn't executed within the time, wait for time
    let time: DispatchTime = .now() + .seconds(1)
    let result: DispatchTimeoutResult = workItem.wait(timeout: time)
    
    
    // result is timeout or success
    print("after waiting: result is \(result)")
}
testWorkItemWaitTimeOut()


// dispatch_block_notify
// https://github.com/apple/swift-corelibs-libdispatch/blob/master/dispatch/block.h#L327-L369

func testWorkItemNotify() {
    let queue = DispatchQueue(label: "queue", attributes: .concurrent)
    let workItem = DispatchWorkItem {
        sleep(2)
        print("done")
    }
    
    queue.async(execute: workItem)
    
    workItem.notify(queue: .main) {
        print("notify")// perform after work finished (2 second).
    }
}

// * Difference between DispatchTime and DispatchWallTime
// DispatchTime stops running when your computer goes to sleep, on the other hand, DispatchWallTime continues running

/*
 
 public struct DispatchWallTime : Comparable {
 
     public let rawValue: dispatch_time_t
 
     public static func now() -> DispatchWallTime
 
     public static let distantFuture: DispatchWallTime
 
     public init(timespec: timespec)
 }
 
 
 public struct DispatchTime : Comparable {
 
     public let rawValue: dispatch_time_t
 
     public static func now() -> DispatchTime
 
     public static let distantFuture: DispatchTime
 
     /// Creates a `DispatchTime` relative to the system clock that
     /// ticks since boot.
     ///
     /// - Parameters:
     ///   - uptimeNanoseconds: The number of nanoseconds since boot, excluding
     ///                        time the system spent asleep
     /// - Returns: A new `DispatchTime`
     /// - Discussion: This clock is the same as the value returned by
     ///               `mach_absolute_time` when converted into nanoseconds.
     public init(uptimeNanoseconds: UInt64)
 
     public var uptimeNanoseconds: UInt64 { get }
 }
 
 */




















