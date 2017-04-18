

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
    
    init(_ closure: @escaping (@escaping (ElementType?) -> Void, @escaping (Error?) -> Void) -> Void)
    func fmap<Result>(_ transform: @escaping (ElementType) -> Result) -> SerialTask<Result>
}

//asyncAfter
//抽象クラス　継承して各operatorクラスを作る

class SerialTask<Element>: Serializable {
    
    typealias ElementType = Element
    
    //task
    typealias Fullfill = (ElementType?) -> Void
    typealias Failure  = (Error?) -> Void
    typealias InitialTask = (@escaping Fullfill, @escaping Failure) -> Void
    typealias FullfillClosure = (@escaping Fullfill) -> Void
    typealias Closure = () -> Void
    
    fileprivate var errorHandler: ((Error) -> Void)?
    
    fileprivate var nextFullfillHandler: ((Element?) -> Void)?
    fileprivate var nextErrorHandler: ((Error?) -> Void)?
    
    required init(_ closure: @escaping InitialTask) {
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
            fullfill(nil)//nilを送るのはちょっといけてない fillFill以外のを用意するか//voidをうまく送りたい
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
        //weak self にすると解放されてしまう
        let fulfill: Fullfill = { value in
            self.nextFullfillHandler?(value)
        }
        
        let failure: Failure = {  error in
            // errorを非optionalにしてもいいかも
            if let handler = self.errorHandler, let error = error {
                handler(error)
            } else {
                self.nextErrorHandler?(error)
            }
        }
        
        task(fulfill, failure)
    }
}

// Operator
// fmap

extension SerialTask {
    // Mapのインスタンスを返す設計にすればMap operatorのインタフェースが明確にできる
    //http://jutememo.blogspot.jp/2008/10/haskell-fmap.html
    func fmap<Result>(_ transform: @escaping (Element) -> Result) -> SerialTask<Result> {
        
        //今の所Fmap使わなくてもいいかも
        // nextFullfillHandlerはFmapがもつべき
        return Fmap<Result> { [weak self] fullfill, error in
            //let _ = ConcurrentTask<Element2>(value: newValue)
            
            guard let me = self else { return }
            
            let next: (Element?) -> Void = { value in
                guard let value = value else { return /* errorの検討 */ }//TODO: - Closure Initの場合はじかれる
                let newValue = transform(value)
                fullfill(newValue)
            }
            
            let failure: (Error?) -> Void = { errorInfo in
                error(errorInfo)//初期化時のfailue実行
            }
            
            me.nextFullfillHandler = next
            me.nextErrorHandler    = failure
        }
    }
    
    
    // convetible準拠させる
    // 帰り値なし
    // - 引数あり
    // - errorあり
    // - 引数なし
    // - fullfill
    
    
    //何も引数を受け取らずに何も返さないDo
    //valueを捨てること許容する？do onNextみたいにvalueは保持して次に流す
    func `do`(_ completionHandler: @escaping () -> Void) -> Do<Element> {
        return Do<Element> { [weak self] fullfill, error in
            //let _ = ConcurrentTask<Element2>(value: newValue)
            
            guard let me = self else { return }
            
            let next: (Element) -> Void = { value in
                completionHandler()
                fullfill()//value
            }
            
            let failure: (Error?) -> Void = { errorInfo in
                error(errorInfo)//初期化時のfailue実行
            }
            
            me.nextFullfillHandler = next
            me.nextErrorHandler    = failure
        }
    }
    
    func doWith() {
        
    }
    
    //fmapWith
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
final class Fmap<Element>: SerialTask<Element> {
    
    required init(_ closure: @escaping InitialTask) {
        super.init(closure)
    }
}

//valueは内部的に次に流す（rxのDoと同じ）SerialTask継承してもいいかも
final class Do<Element> {
    //completehandler
    typealias InitialTask = (@escaping () -> Void, @escaping (Error?) -> Void) -> Void
    
    init(_ closure: @escaping InitialTask) {
        excuteTask(closure)
    }
    
    func excuteTask(_ task: InitialTask) {
        //weak self にすると解放されてしまう
        let fulfill: () -> Void = { value in
            
        }
        
        let failure: (Error?) -> Void = {  error in
            // errorを非optionalにしてもいいかも
            if let handler = self.errorHandler, let error = error {
                handler(error)
            } else {
                self.nextErrorHandler?(error)
            }
        }
        
        task(fulfill, failure)
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
