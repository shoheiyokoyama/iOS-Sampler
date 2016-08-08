//
//  Pageable.swift
//  PageViewController
//
//  Created by 横山祥平 on 2016/08/08.
//  Copyright © 2016年 Shohei. All rights reserved.
//

import UIKit

protocol Pageable {
    // identifier unify ClassName(except for ViewController) . instance own identifier.
    // e.g.) Data.ItemList (in the case DataViewController)
    
    var identifier: String? { get set }
    var identifiers: [String] { get set }
    
    //TODO: change data type in the near future
    var items: [Int]? { get set }
}
