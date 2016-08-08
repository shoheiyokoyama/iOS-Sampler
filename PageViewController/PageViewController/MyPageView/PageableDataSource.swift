//
//  PageableDataSource.swift
//  PageViewController
//
//  Created by 横山祥平 on 2016/08/08.
//  Copyright © 2016年 Shohei. All rights reserved.
//

import UIKit

protocol PageableDataSource {
    var identifiers: [String] { get set }
    
    init<Controller: UIViewController where Controller: Pageable>(dataController: Controller)
    
    func indexAtIdentifier(identifier: String) -> Int
    func nextIndexAtController<Controller: UIViewController where Controller: Pageable>(controller: Controller) -> Int
    func viewControllerAtIndex(index: Int) -> UIViewController?
    
    func beforeViewControllerWithIdentifier(viewController: UIViewController) -> (UIViewController?, String)?
    func afterViewControllerWithIdentifier(viewController: UIViewController) -> (UIViewController?, String)?
}

extension PageableDataSource {
    func indexAtIdentifier(identifier: String) -> Int {
        return identifiers.indexOf(identifier) ?? Foundation.NSNotFound
    }
    
    func nextIndexAtController<Controller: UIViewController where Controller: Pageable>(controller: Controller) -> Int {
        guard let identifier = controller.identifier else { return Foundation.NSNotFound }
        let index = indexAtIdentifier(identifier)
        return index == 0 ? 1 : 0
    }
    
    func viewControllerAtIndex(index: Int) -> UIViewController? {
        if identifiers.count == 0 || index >= identifiers.count {
            return nil
        }
        
        let identifier = identifiers[index]
        guard let name = identifier.componentsSeparatedByString(".").first else { return nil }
        return UIStoryboard(name: name, bundle: nil).instantiateViewControllerWithIdentifier(name)
    }
    
    func beforeViewControllerWithIdentifier(viewController: UIViewController) -> (UIViewController?, String)? {
        guard let viewController = viewController as? Pageable,
            identifier = viewController.identifier else {
                return nil
        }
        
        var index = indexAtIdentifier(identifier)
        if index == 0 || index == Foundation.NSNotFound {
            return nil
        }
        index -= 1
        
        return (viewControllerAtIndex(index), identifiers[index])
    }
    
    func afterViewControllerWithIdentifier(viewController: UIViewController) -> (UIViewController?, String)? {
        guard let viewController = viewController as? Pageable,
            identifier = viewController.identifier else {
                return nil
        }
        
        var index = indexAtIdentifier(identifier)
        
        if index == Foundation.NSNotFound {
            return nil
        }
        
        index += 1
        if index == identifiers.count {
            return nil
        }
        
        return (viewControllerAtIndex(index), identifiers[index])
    }
}