

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

protocol Serializable {
    associatedtype ElementType
    
    //init(_ closure: @escaping (@escaping (ElementType?) -> Void, @escaping (Error?) -> Void) -> Void)
    func fmap<Result>(_ transform: @escaping (ElementType) -> Result) -> SerialTask<Result>
}

//asyncAfter
//抽象クラス　継承して各operatorクラスを作る

final class SerialTask<Element>: Serializable {
    
    typealias ElementType = Element
    
    //task
    typealias Fullfill = (ElementType?) -> Void
    typealias Failure  = (Error?) -> Void
    typealias InitialTask = (@escaping Fullfill, @escaping Failure) -> Void
    typealias FullfillClosure = (@escaping Fullfill) -> Void
    typealias Closure = () -> Void
    
    fileprivate var errorHandler: ((Error) -> Void)?
    
    fileprivate var manager: Manager = Manager<Element>()
    
    init(_ closure: @escaping InitialTask) {
        excuteTask(closure)
    }
    
    convenience init(_ closure: @escaping FullfillClosure) {
        self.init({ fullfill, failure in
            closure(fullfill)
        })
    }
    
    convenience init(_ closure: @escaping Closure) {
        self.init({ fullfill, failure in
            closure()
            fullfill(nil)//nilを送るのはちょっといけてない fillFill以外のを用意するか
        })
    }
    
    /*
     convenience init(value: Element) {
     let task: fullfillWithFailure = { fullfill, failure in
     fullfill(value)
     }
     self.init(task)
     }*/
    
    func excuteTask(_ task: InitialTask) {
        let fulFill: Fullfill = { value in
            self.manager.excuteNextHandler(with: value)
        }
        
        let failure: Failure = { error in
            //errroの値で分岐入れたほうがわかりやすいかも
            self.manager.excuteErrorHandler(with: error)
            self.errorHandler?(error!)//catchErrorHandlerのクロージャまでnilなのでそこまで行ったら実行される
        }
        
        task(fulFill, failure)
    }
}

// Operator
// fmap

extension SerialTask {
    // Mapのインスタンスを返す設計にすればMap operatorのインタフェースが明確にできる
    //http://jutememo.blogspot.jp/2008/10/haskell-fmap.html
    @discardableResult
    func fmap<Result>(_ transform: @escaping (Element) -> Result) -> SerialTask<Result> {
        // return Fmap<NewElement>() .....
        return SerialTask<Result> { [weak manager] fullfill, error in
            //let _ = ConcurrentTask<Element2>(value: newValue)
            
            guard let manager = manager else { return }
            
            let next: (Element?) -> Void = { value in
                guard let value = value else { return /* errorの検討 */ }//TODO: - Closure Initの場合はじかれる
                let newValue = transform(value)
                fullfill(newValue)
            }
            
            let failure: (Error?) -> Void = { errorInfo in
                error(errorInfo)//初期化時のfailue実行
            }
            
            manager.appendNextHandler(next)
            manager.appendErrorHandler(failure)
        }
    }
    
    //引数がある場合も
    // convetible準拠させる
    /*
    func `do`() -> Convertible {
        return
    }*/
}

protocol ErrorCatchable {
    func catchError(_ errorHandler: @escaping (Error) -> Void)
}

extension SerialTask: ErrorCatchable {
    @discardableResult
    func catchError(_ errorHandler: @escaping (Error) -> Void) {
        self.errorHandler = errorHandler
    }
}

// Functor
//protocol Functor { }

//TODO: - serialize ErrorCatchableなど継承 convertibleは準拠させない
final class Fmap<Element> {
    init(_ transfrom: () -> Void) {
        
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
