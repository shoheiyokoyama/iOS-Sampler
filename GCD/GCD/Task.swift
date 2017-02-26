//
//  Task.swift
//  GCD
//
//  Created by Shiohei Yokoyama on 2016/11/19.
//  Copyright © 2016年 Shohei. All rights reserved.
//

import UIKit

// serial class
// concurrent class

final class TaskManager {
    
    var tasks: [NextObjectErrorClosure] = []
    
    typealias NextObjectErrorClosure = (Any? , @escaping (Any?) -> Void, @escaping (Error?) -> Void) -> Void
    typealias NextObjectClosure = (Any? , @escaping (Any?) -> Void) -> Void
    typealias ObjectNextClosure = (@escaping (Any?) -> Void) -> Void
    typealias VoidNextClosure = () -> Void
    
    //init(_ closure: () -> Void) {}
    
    func next(closure: @escaping VoidNextClosure) -> Self {
        let task: NextObjectErrorClosure = { _, done, _ in
            closure()
            done(nil)
        }
        tasks.append(task)
        return self
    }
    
    func next(closure: @escaping ObjectNextClosure) -> Self {
        let task: NextObjectErrorClosure = { object, done, _ in
            closure(done)
        }
        tasks.append(task)
        return self
    }
    
    func next(closure: @escaping NextObjectClosure) -> Self {
        let task: NextObjectErrorClosure = { object, done, _ in
            closure(object, done)
        }
        tasks.append(task)
        return self
    }
    
    func next(closure: @escaping NextObjectErrorClosure) -> Self {
        tasks.append(closure)
        return self
    }
    
    func run() {
        runNext()
    }
    
    func runNext(object: Any? = nil) {
        if tasks.isEmpty { return }
        
        let task = tasks.remove(at: 0)
        
        task(object, { nextObject in
            self.runNext(object: nextObject)
        }, { error in
            print(error ?? "Nil")
        })
    }
}

class Task { }
