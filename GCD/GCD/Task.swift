//
//  Task.swift
//  GCD
//
//  Created by Shohei Yokoyama on 2016/11/19.
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
    
    init(_ closure: @escaping NextObjectErrorClosure) {
        tasks.append(closure)
    }
    
    convenience init(_ closure: @escaping NextObjectClosure) {
        let task: NextObjectErrorClosure = { object, done, _ in
            closure(object, done)
        }
        self.init(task)
    }
    
    convenience init(_ closure: @escaping ObjectNextClosure) {
        let task: NextObjectErrorClosure = { object, done, _ in
            closure(done)
        }
        self.init(task)
    }
    
    convenience init(_ closure: @escaping VoidNextClosure) {
        let task: NextObjectErrorClosure = { _, done, _ in
            closure()
            done(nil)
        }
        self.init(task)
    }
}

extension TaskManager {
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

extension TaskManager {
    func next(closure: @escaping VoidNextClosure) -> Self {
        let task: NextObjectErrorClosure = { _, done, _ in
            closure()
            done(nil)//doneをしてない場合は同期的にdone処理
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
}

class Task { }
