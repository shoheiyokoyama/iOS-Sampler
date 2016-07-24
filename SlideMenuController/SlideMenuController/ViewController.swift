//
//  ViewController.swift
//  SlideMenuController
//
//  Created by 横山祥平 on 2016/07/24.
//  Copyright © 2016年 Shohei. All rights reserved.
//

import UIKit

class ViewController: UIViewController, Slidable {
    
    var slideMenuState: SlideMenuState = .close
    
    var shadowView = UIView()
    
    var childViewController: UIViewController = {
        let viewController = UIViewController()
        viewController.view.backgroundColor = UIColor.redColor()
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSlideMenu()
        
        registerRecognizer()
    }
    
    private func registerRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedView(_:)))
        view.addGestureRecognizer(tapGesture)
        
        let rightPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSlideMenuGesture(_:)))
        childViewController.view.addGestureRecognizer(rightPanGesture)
    }
    
    @objc private func handleSlideMenuGesture(panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
        case .Changed:
            let translation = panGesture.translationInView(panGesture.view)
            updateFrame(translation)
        case .Ended, .Cancelled:
            let velocity: CGPoint = panGesture.velocityInView(panGesture.view)
            let info = getSlideMenuInfo(velocity)
            
            if info.state == .close {
                childViewController.beginAppearanceTransition(false, animated: true)
                hideSlideMenuController(info.durationTime)
            } else {
                childViewController.beginAppearanceTransition(true, animated: true)
                showSlideMenuController(info.durationTime)
            }
        default:
            break
        }
    }
    
    @objc private func tappedView(sender: UITapGestureRecognizer) {
        if slideMenuState == .open {
            hideSlideMenuController(SlideMenuConstants.defaultDuration)
        }
    }
    
    @IBAction func tap(sender: AnyObject) {
        if slideMenuState == .close {
            showSlideMenuController(SlideMenuConstants.defaultDuration)
        }
    }
}

