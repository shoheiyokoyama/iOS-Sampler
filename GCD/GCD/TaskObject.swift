//
//  TaskObject.swift
//  GCD
//
//  Created by Shohei Yokoyama on 2017/02/26.
//  Copyright © 2017年 Shohei. All rights reserved.
//

import UIKit

protocol Task: class {
    associatedtype ElementType
}

class ConcurrentTask<Element>: Task {
    typealias ElementType = Element
    
    typealias NextObjectErrorClosure = (Element? , @escaping (Element?) -> Void, @escaping (Error?) -> Void) -> Void
    typealias NextObjectClosure = (Element? , @escaping (Element?) -> Void) -> Void
    typealias ObjectNextClosure = (@escaping (Element?) -> Void) -> Void
    typealias VoidNextClosure = () -> Void
    
    var task: NextObjectErrorClosure?
    
    func make(closure: @escaping VoidNextClosure) {
        let task: NextObjectErrorClosure = { _, done, _ in
            closure()
            done(nil)
        }
        self.task = task
    }
    
    func make(closure: @escaping ObjectNextClosure) {
        let task: NextObjectErrorClosure = { object, done, _ in
            closure(done)
        }
        self.task = task
    }
    
    func make(closure: @escaping NextObjectClosure) {
        let task: NextObjectErrorClosure = { object, done, _ in
            closure(object, done)
        }
        self.task = task
    }
    
    func make(closure: @escaping NextObjectErrorClosure) {
        self.task = closure
    }
}




class SerialTask<Element>: Task {
    typealias ElementType = Element
}

