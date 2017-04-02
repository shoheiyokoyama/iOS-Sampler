//
//  StateManager.swift
//  GCD
//
//  Created by Shohei Yokoyama on 2017/03/12.
//  Copyright © 2017年 Shohei. All rights reserved.
//

import Foundation

final class Manager<V> {
    // Optionalについては再検討
    var nextHandler: ((V?) -> Void)?
    var errorHandler: ((Error?) -> Void)?
    
    func excuteNextHandler(with value: V?) {
        nextHandler?(value)
    }
    
    func excuteErrorHandler(with error: Error?) {
        errorHandler?(error)
    }
    
    func appendNextHandler(_ handler: @escaping (V?) -> Void) {
        nextHandler = handler
    }
    
    func appendErrorHandler(_ handler: @escaping (Error?) -> Void) {
        errorHandler = handler
    }
}
