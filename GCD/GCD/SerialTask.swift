

//
//  ConcurrentTask.swift
//  GCD
//
//  Created by Shohei Yokoyama on 2017/03/04.
//  Copyright © 2017年 Shohei. All rights reserved.
//

import Foundation

enum TaskError: Error {
    case valueNil
}

protocol SerialExecutable: Convertible {
    associatedtype ElementType
    
    init(_ closure: @escaping (@escaping (ElementType?) -> Void, @escaping (Error?) -> Void) -> Void)
}

final class SerialTask<Element>: SerialExecutable {
    
    typealias ElementType = Element
    
    //task
    typealias Fullfill = (ElementType?) -> Void
    typealias Failure  = (Error?) -> Void
    typealias FullfillWithFailureClosure = (@escaping Fullfill, @escaping Failure) -> Void
    typealias fullfillClosure = (@escaping Fullfill) -> Void
    typealias Closure = () -> Void
    
    fileprivate var catchErrorHandler: ((Error) -> Void)?
    
    fileprivate var task: FullfillWithFailureClosure
    
    fileprivate var manager: Manager = Manager<Element>()
    
    init(_ closure: @escaping FullfillWithFailureClosure) {
        self.task = closure
        setup()
    }
    
    convenience init(_ closure: @escaping fullfillClosure) {
        self.init({ fullfill, failure in
            closure(fullfill)
        })
    }
    
    convenience init(_ closure: @escaping Closure) {
        self.init({ fullfill, failure in
            closure()
            fullfill(nil)//todo
        })
    }
    
    /*
     convenience init(value: Element) {
     let task: fullfillWithFailure = { fullfill, failure in
     fullfill(value)
     }
     self.init(task)
     }*/
    
    func setup() {
        let fulFill: Fullfill = { value in
            self.manager.value = value
            self.manager.excuteSuccessHandler()
        }
        
        let failure: Failure = { error in
            self.manager.error = error
            self.manager.excuteFailureHandler()
            self.catchErrorHandler?(error!)
        }
        
        task(fulFill, failure)
    }
}

// Operator
extension SerialTask {
    @discardableResult
    func map<Element2>(_ closure: @escaping (Element) -> Element2) -> SerialTask<Element2> {
        
        return SerialTask<Element2> { fullfill,  error in
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

//TODO: -
/*
 extension ConcurrentTask {
 func make(closure: @escaping CompletionHandler) {
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
 */
