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
    
    /*
    convenience init(value: Element) {
        let task: fullfillWithFailure = { fullfill, failure in
            fullfill(value)
        }
        self.init(task)
    }*/
    
    func run() {
        
        let fulFill: FullFill = { value in
            self.manager.value = value
            self.manager.excuteSuccessHandler()
        }
        
        let failure: Failure = { error in
            self.manager.error = error
            self.manager.excuteFailureHandler()
            self.catchErrorHandler?(error!)
        }
        
        self.task!(fulFill, failure)
    }
    
    var catchErrorHandler: ((Error) -> Void)?
}

extension ConcurrentTask {
    @discardableResult
    func map<Element2>(_ closure: @escaping (Element) -> Element2) -> ConcurrentTask<Element2> {
        
        return ConcurrentTask<Element2> { fullfill,  error in
            //let _ = ConcurrentTask<Element2>(value: newValue) 
            
            let success: (Element) -> Void = { value1 in
                let newValue = closure(self.manager.value!)
                fullfill(newValue)
            }
            
            let failure: (Error) -> Void = { errorInfo in
                error(errorInfo)
            }
            
            self.manager.successHandler = success
            self.manager.FailureHandler = failure
        }
    }
    
    @discardableResult 
    func catchError(_ closure: @escaping (Error) -> Void) {
        self.catchErrorHandler = closure
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
    var error: Error?
    
    var successHandler: ((V) -> Void)?
    var FailureHandler: ((Error) -> Void)?
    
    func excuteSuccessHandler() {
        successHandler?(value!)
    }
    
    func excuteFailureHandler() {
        FailureHandler?(error!)
    }
    
    func appendSuccessHandler(_ handler: @escaping (V) -> Void) {
        self.successHandler = handler
    }
    
    func appendFailureHandler(_ handler: @escaping (Error) -> Void) {
        self.FailureHandler = handler
    }
}

enum TaskError: Error {
    case valueNil
}
