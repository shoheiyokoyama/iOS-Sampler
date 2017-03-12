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

protocol ConcurrentExecutable: Convertible {
    associatedtype ElementType
    
    //Needs?
    var task: (@escaping (ElementType?) -> Void, @escaping (Error?) -> Void) -> Void { get set }
    init(_ closure: @escaping (@escaping (ElementType?) -> Void, @escaping (Error?) -> Void) -> Void)
}

final class ConcurrentTask<Element>: ConcurrentExecutable {
    
    typealias ElementType = Element
    
    //task
    typealias FullFill = (ElementType?) -> Void
    typealias Failure  = (Error?) -> Void
    typealias fullfillWithFailure = (@escaping FullFill, @escaping Failure) -> Void
    typealias fullfillClosure = (@escaping FullFill) -> Void
    
    typealias CompletionHandler = () -> Void
    var catchErrorHandler: ((Error) -> Void)?
    
    var task: fullfillWithFailure
    
    var manager: Manager = Manager<Element>()
    
    init(_ closure: @escaping fullfillWithFailure) {
        self.task = closure
        run()
    }
    
    convenience init(_ closure: @escaping fullfillClosure) {
        self.init({ fullfill, failure in
            closure(fullfill)
        })
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
        
        self.task(fulFill, failure)
    }
}

// Operator
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
