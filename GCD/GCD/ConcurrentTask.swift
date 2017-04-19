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
 - group
 - Semaphore
 - iterator
 */

// serialのobjectで帰り値、completionHadndlerがないものに対して切り替えられるようにする
final class ConcurrentTask: ConcurrentExecutable {
    
    private let queue = DispatchQueue(label: key, attributes: .concurrent)
    
    func `do`(_ closure: @escaping () -> Void) -> ConcurrentTask {
        queue.async(execute: closure)
        return self
    }
}
