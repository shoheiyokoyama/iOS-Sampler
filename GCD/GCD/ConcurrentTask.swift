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


protocol ConcurrentExecutable {
    
}

final class ConcurrentTask: ConcurrentExecutable {
    private let queue = DispatchQueue(label: "consurrentKey", attributes: .concurrent)
    /*
    func execute(_ closure: @escaping () -> Void) -> ConcurrentTask {
        queue.async(execute: closure)
    }*/
}
