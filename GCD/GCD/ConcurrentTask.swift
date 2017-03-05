//
//  ConcurrentTask.swift
//  GCD
//
//  Created by Shohei Yokoyama on 2017/03/04.
//  Copyright © 2017年 Shohei. All rights reserved.
//

import Foundation

protocol ObjectCarryable: Convertible {
    associatedtype ElementType
}

final class ConcurrentTask<Element>: ObjectCarryable {
    typealias ElementType = Element
    
    typealias FullFill = (Element?) -> Void
    typealias Failure  = (Error?) -> Void
    
    //task
    typealias fullfillWithFailure = (@escaping FullFill, @escaping Failure) -> Void
    typealias fullfillClosure = (@escaping FullFill) -> Void
    typealias completionHandler = () -> Void
    
    var task: fullfillWithFailure?
    
   
    var manager: Manager = Manager<Element>()
    
    init(_ closure: @escaping fullfillWithFailure) {
        self.task = closure
        run()
    }
    
    convenience init(_ closure: @escaping fullfillClosure) {
        let task: fullfillWithFailure = { fullfill, failure in
            closure(fullfill)
        }
        self.init(task)
    }
    
    func run() {
        
        self.task!({ fullfill in
            print(fullfill ?? "")
            self.manager.value = fullfill
            self.manager.handler?()
            
        }, { error in
            print(error ?? "")
        })
    }
}

extension ConcurrentTask {
    func next<Element2>(_ closure: @escaping (Element?) -> Element2) {
        let handler: () -> Void = {
            let _ = closure(self.manager.value)
        }
        
        self.manager.handler = handler
    }
}


extension ConcurrentTask {
    func make(closure: @escaping completionHandler) {
        let task: fullfillWithFailure = { done, _ in
            closure()
            done(nil)
        }
        self.task = task
    }
    
    func make(closure: @escaping fullfillClosure) {
        let task: fullfillWithFailure = { done, _ in
            closure(done)
        }
        self.task = task
    }
    
    func make(closure: @escaping fullfillWithFailure) {
        self.task = closure
    }
}

class Manager<V> {
    var value: V?
    var handler: (() -> Void)?
}
