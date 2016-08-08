//
//  MyPageViewDataSource.swift
//  PageViewController
//
//  Created by 横山祥平 on 2016/08/08.
//  Copyright © 2016年 Shohei. All rights reserved.
//

import UIKit

final class MyPageViewDataSource: NSObject, PageableDataSource {
    var identifiers: [String] = []
    //[identifier: [APIのデータ], ...]
    var data: [String: [Int]] = [:]
    
    //APIなどで取得するデータ
    private let dammyModelData: [[Int]] = [
        [0, 1, 2, 3, 4, 5, 6, 7],
        [6, 7, 8, 9, 10, 11, 12, 13, 14]
    ]
    
    convenience init<Controller: UIViewController where Controller: Pageable>(dataController: Controller) {
        self.init()
        identifiers = dataController.identifiers
        
        //TODO: APIが出来たら
        identifiers.enumerate().forEach { index, identifier in
            data[identifier] = dammyModelData[index]
        }
    }
}

extension MyPageViewDataSource: UIPageViewControllerDataSource {
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard let beforeItems = beforeViewControllerWithIdentifier(viewController),
            viewController = beforeItems.0 as? MyDataViewController else { return nil }
        
        let identifier = beforeItems.1
        viewController.identifier = identifier
        viewController.items      = data[identifier]
        return viewController
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard let afterItems = afterViewControllerWithIdentifier(viewController),
            viewController = afterItems.0 as? MyDataViewController else { return nil }
        
        let identifier = afterItems.1
        viewController.identifier = identifier
        viewController.items      = data[identifier]

        return viewController
    }
}

