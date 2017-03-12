//
//  StateManager.swift
//  GCD
//
//  Created by 横山祥平 on 2017/03/12.
//  Copyright © 2017年 Shohei. All rights reserved.
//

import Foundation

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
