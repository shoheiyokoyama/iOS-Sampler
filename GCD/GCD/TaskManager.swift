//
//  TaskManager.swift
//  GCD
//
//  Created by Shohei Yokoyama on 2016/11/19.
//  Copyright © 2016年 Shohei. All rights reserved.
//

import UIKit

protocol TaskManageable {
    func run()
}

final class TaskManager: TaskManageable {
    typealias NextObjectErrorClosure = (Any? , @escaping (Any?) -> Void, @escaping (Error?) -> Void) -> Void
    typealias NextObjectClosure = (Any? , @escaping (Any?) -> Void) -> Void
    typealias ObjectNextClosure = (@escaping (Any?) -> Void) -> Void
    typealias VoidNextClosure = () -> Void
    
    var tasks: [NextObjectErrorClosure] = []
    let initialTask: NextObjectErrorClosure
    
    init(_ closure: @escaping NextObjectErrorClosure) {
        tasks.append(closure)
        initialTask = closure
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
    
    //http://ameblo.jp/principia-ca/entry-12142313027.html
    //var testArray: [Task] = []
    
    
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

// run
extension TaskManager {
    func _run() {
        initialTask(nil, { nextObject in
            self.runNext(object: nextObject)
        }, { error in
            print(error ?? "Nil")
        })
    }
    
    func next<T>(closure: @escaping ConcurrentTask<T>.NextObjectErrorClosure) -> ConcurrentTask<T> {
        let nextConcurrentTask = ConcurrentTask<T>()
        nextConcurrentTask.make(closure: closure)
        return nextConcurrentTask
    }
    
    func next<T>(closure: @escaping ConcurrentTask<T>.NextObjectClosure) -> ConcurrentTask<T> {
        let nextConcurrentTask = ConcurrentTask<T>()
        nextConcurrentTask.make(closure: closure)
        return nextConcurrentTask
    }
    
    func next<T>(closure: @escaping ConcurrentTask<T>.ObjectNextClosure) -> ConcurrentTask<T> {
        let nextConcurrentTask = ConcurrentTask<T>()
        nextConcurrentTask.make(closure: closure)
        return nextConcurrentTask
    }
    
    func next<T: Any>(closure: @escaping ConcurrentTask<T>.VoidNextClosure) -> ConcurrentTask<T> {
        let nextConcurrentTask = ConcurrentTask<T>()
        nextConcurrentTask.make(closure: closure)
        return nextConcurrentTask
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


