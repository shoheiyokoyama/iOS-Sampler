//
//  ConcurrentTask.swift
//  GCD
//
//  Created by Shohei Yokoyama on 2017/03/04.
//  Copyright © 2017年 Shohei. All rights reserved.
//

import Foundation

// for in
// error
// switch task

// Serial -> Concurrent : Objectを返さないOperator
// ConcurrentGrrent -> Serial : Group以外？

protocol ConcurrentExecutable {
    
}

extension ConcurrentExecutable {
    static var key: String {
        return "consurrentKey"
    }
}

/*
 - group //keyごとに
 - Semaphore
 - iterator
 */

// serialのobjectで帰り値、completionHadndlerがないものに対して切り替えられるようにする
final class ConcurrentTask: ConcurrentExecutable {
    
    typealias Block = () -> Void
    
    private let queue = DispatchQueue(label: key, attributes: .concurrent)
    
    private var tasks: [Block] = []
    
    // ConcurrentConvertibleの時のinitializerはinternalにして　ConcurrentTaskのinitializerはpublicにしたい
    internal convenience init(_ block: @escaping (@escaping Block) -> Void) {
        self.init()
        
        let c: Block = {
            self.run()
        }
        block(c)
    }
    
    public convenience init(initialBlock: @escaping Block) {
        self.init()
        
        
    }
    
    func `do`(_ closure: @escaping Block) -> ConcurrentTask {
        tasks.append(closure)
        return self
    }
    
    //serialのタスク完了時か初期化時
    private func run() {
        tasks.forEach { [weak self] task in
            self?.queue.async(execute: task)
        }
    }
}
