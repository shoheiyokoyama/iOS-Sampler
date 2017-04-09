

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

//asyncAfter

final class SerialTask<Element>: SerialExecutable {
    
    typealias ElementType = Element
    
    //task
    typealias Fullfill = (ElementType?) -> Void
    typealias Failure  = (Error?) -> Void
    typealias FullfillWithFailureClosure = (@escaping Fullfill, @escaping Failure) -> Void
    typealias FullfillClosure = (@escaping Fullfill) -> Void
    typealias Closure = () -> Void
    
    fileprivate var catchErrorHandler: ((Error) -> Void)?
    
    fileprivate var task: FullfillWithFailureClosure
    
    fileprivate var manager: Manager = Manager<Element>()
    
    init(_ closure: @escaping FullfillWithFailureClosure) {
        self.task = closure
        setup()
    }
    
    convenience init(_ closure: @escaping FullfillClosure) {
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
            self.manager.excuteNextHandler(with: value)
        }
        
        let failure: Failure = { error in
            //errroの値で分岐入れたほうがわかりやすいかも
            self.manager.excuteErrorHandler(with: error)
            self.catchErrorHandler?(error!)//catchErrorHandlerのクロージャまでnilなのでそこまで行ったら実行される
        }
        
        task(fulFill, failure)
    }
}

// Operator
extension SerialTask {
    // Mapのインスタンスを返す設計にすればMap operatorのインタフェースが明確にできる
    //http://jutememo.blogspot.jp/2008/10/haskell-fmap.html
    @discardableResult
    func fmap<NewElement>(_ closure: @escaping (Element) -> NewElement) -> SerialTask<NewElement> {//functorを返す
        // return Fmap<NewElement>() .....
        return SerialTask<NewElement> { [weak manager] fullfill, error in
            //let _ = ConcurrentTask<Element2>(value: newValue)
            
            guard let manager = manager else { return }
            
            let next: (Element?) -> Void = { value in
                guard let value = value else { return /* errorの検討 */ }
                let newValue = closure(value)
                fullfill(newValue)
            }
            
            let failure: (Error?) -> Void = { errorInfo in
                error(errorInfo)//初期化時のfailue実行
            }
            
            manager.appendNextHandler(next)
            manager.appendErrorHandler(failure)
        }
    }
    
    @discardableResult
    func catchError(_ closure: @escaping (Error) -> Void) {
        catchErrorHandler = closure
    }
}

// Functor
protocol Functor {
    func fmap()
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
