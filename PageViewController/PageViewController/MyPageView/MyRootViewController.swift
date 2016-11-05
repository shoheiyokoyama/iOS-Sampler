//
//  MyRootViewController.swift
//  PageViewController
//
//  Created by 横山祥平 on 2016/08/08.
//  Copyright © 2016年 Shohei. All rights reserved.
//

import UIKit

class MyRootViewController: UIViewController {

    private let pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
    private var dataSource: MyPageViewDataSource?
    
    private var currentDataController: MyDataViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func changePage() {
        let index = 0
        
        guard let dataController = self.dataSource?.viewControllerAtIndex(index) as? MyDataViewController,
            identifier = self.dataSource?.identifiers[index] else {
                return
        }
        
        dataController.identifier = identifier
        dataController.items      = self.dataSource?.data[identifier]
//        self.currentDataController = dataController
        
        let direction: UIPageViewControllerNavigationDirection = index == 0 ? .Reverse : .Forward
        self.pageViewController.setViewControllers([dataController], direction: direction, animated: true, completion: nil)
//        self.selectedIndex = index
    }
    
    private func setupMessageListController() {
        let dataController = MyDataViewController.instantiate()
        dataController.items = [1, 2, 3, 4] //TODO: API
        
        dataSource = MyPageViewDataSource(dataController: dataController)
        pageViewController.dataSource = dataSource
        pageViewController.delegate   = self
        
//        currentDataController = dataController
        pageViewController.setViewControllers([dataController], direction: .Forward, animated: false, completion: nil)
        
//        pageViewController.view.frame = CGRect(x: 0, y: controllSwitchHeight, width: view.bounds.width, height: view.bounds.height - controllSwitchHeight)
        
        
        view.addSubview(pageViewController.view)
        addChildViewController(pageViewController)
        pageViewController.didMoveToParentViewController(self)
    }
    
    private func updateSelection(viewController: MyDataViewController) {
        //TODO: スクロールとBrickViewのView更新処理
        if let index = dataSource?.nextIndexAtController(viewController) where index != Foundation.NSNotFound {
//            controllSwitchView.changeSlider(index)
        }
    }

}


extension MyRootViewController: UIPageViewControllerDelegate {
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let previousViewController = previousViewControllers.first as? MyDataViewController else { return }
        if previousViewController.identifier == currentDataController?.identifier {
            updateSelection(previousViewController)
            currentDataController = pageViewController.viewControllers?.first as? MyDataViewController
        }
    }
}