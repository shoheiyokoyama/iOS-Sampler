//
//  Extension.swift
//  StoryboardInstansate
//
//  Created by 横山祥平 on 2016/06/30.
//  Copyright © 2016年 Shohei. All rights reserved.
//

import UIKit

extension String {
    static func className(aClass: AnyClass) -> String {
        guard let className = NSStringFromClass(aClass).componentsSeparatedByString(".").last else { return "" }
        return className
    }
}

extension UIStoryboard {
    static func instantiateA<T: UIViewController>(viewController: T.Type) -> T {
        return UIStoryboard(name: "ViewController", bundle: nil).instantiateInitialViewController() as! T
    }
    
    static func instantiateB<T: UIViewController>(viewController: T.Type) -> T {
        let name = String.className(T).stringByReplacingOccurrencesOfString("ViewController", withString: "")
        return UIStoryboard(name: name, bundle: nil).instantiateViewControllerWithIdentifier(name) as! T
    }
}
