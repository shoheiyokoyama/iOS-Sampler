//
//  Slidable.swift
//  SlideMenuController
//
//  Created by 横山祥平 on 2016/07/24.
//  Copyright © 2016年 Shohei. All rights reserved.
//

import UIKit

enum SlideMenuState {
    case open, close
}

struct SlideMenuInfo {
    var state: SlideMenuState
    var durationTime: Double
}

struct SlideMenuConstants {
    static let slideMenuOriginRatio: CGFloat = 0.4
    static let closePoint: CGFloat           = 100
    
    static let shadowAlpha: CGFloat = 0.5
    
    static let defaultDuration: Double = 0.5
    static let minDuration: Double     = 0.18
    static let maxDuration: Double     = 0.8
}

protocol Slidable: class {
    var slideMenuState: SlideMenuState { get set }
    var shadowView: UIView { get set }
    var childViewController: UIViewController { get set }
    
    func setupSlideMenu()
    func getSlideMenuInfo(velocity: CGPoint) -> SlideMenuInfo
    func updateFrame(translation: CGPoint)
    
    func showSlideMenuController(duration: Double)
    func hideSlideMenuController(duration: Double)
}

extension Slidable where Self: UIViewController {
    func setupSlideMenu() {
        shadowView.frame           = view.frame
        shadowView.backgroundColor = .blackColor()
        shadowView.alpha           = 0
        view.addSubview(shadowView)
        
        childViewController.view.frame = CGRect(x: view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height)
    }
    
    func getSlideMenuInfo(velocity: CGPoint) -> SlideMenuInfo {
        let currentOrigin = childViewController.view.frame.origin.x
        
        var info = SlideMenuInfo(state: .close, durationTime: 0.0)
        
        var duration: Double = SlideMenuConstants.defaultDuration
        if velocity.x != 0.0 {
            duration = Double(fabs(currentOrigin - CGRectGetWidth(view.bounds)) / velocity.x)
            duration = Double(fmax(SlideMenuConstants.minDuration, fmin(SlideMenuConstants.maxDuration, duration)))
        }
        info.durationTime = duration
        
        let shouldClosePoint             = view.bounds.width - SlideMenuConstants.closePoint
        let shouldCloseVelocity: CGFloat = 1000
        
        info.state = childViewController.view.frame.origin.x > shouldClosePoint ? .close : .open
        
        if velocity.x > shouldCloseVelocity {
            info.state = .close
        }
        return info
    }
    
    func updateFrame(translation: CGPoint) {
        let openedFrame        = CGRect(x: view.bounds.width * SlideMenuConstants.slideMenuOriginRatio, y: 0, width: view.bounds.width, height: view.bounds.height)
        var newOrigin: CGFloat = openedFrame.origin.x
        newOrigin              += translation.x
        
        var newFrame: CGRect = openedFrame
        
        let minOrigin: CGFloat = CGRectGetWidth(view.bounds)
        let maxOrigin: CGFloat = CGRectGetWidth(view.bounds) * SlideMenuConstants.slideMenuOriginRatio
        
        if newOrigin > minOrigin {
            newOrigin = minOrigin
        } else if newOrigin < maxOrigin {
            newOrigin = maxOrigin
        }
        
        newFrame.origin.x                 = newOrigin
        childViewController.view.frame = newFrame
        
        let maxDistance  = minOrigin - maxOrigin
        let dragDistance = newOrigin - maxOrigin
        let dragRatio    = dragDistance / maxDistance
        shadowView.alpha = SlideMenuConstants.shadowAlpha * (1 - dragRatio)
    }
    
    func hideSlideMenuController(duration: Double) {
        childViewController.willMoveToParentViewController(nil)
        
        UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseInOut,
            animations: { [weak self] in
                guard let `self` = self else { return }
                self.childViewController.view.frame.origin.x = self.view.bounds.width
                self.shadowView.alpha = 0
            },
            completion: { [weak self] _ in
                guard let `self` = self else { return }
                self.childViewController.view.removeFromSuperview()
                self.childViewController.removeFromParentViewController()
                self.childViewController.didMoveToParentViewController(self)
                self.slideMenuState = SlideMenuState.close
            }
        )
    }
    
    func showSlideMenuController(duration: Double) {
        addChildViewController(childViewController)
        
        let width  = view.bounds.width
        let height = view.bounds.height
        
        var frame = CGRect(x: width, y: 0, width: width, height: height)
        if frame.origin.x > childViewController.view.frame.origin.x {
            frame.origin.x = childViewController.view.frame.origin.x
        }
        
        childViewController.view.frame = frame
        view.addSubview(childViewController.view)
        
        UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseInOut,
            animations: { [weak self] in
                guard let `self` = self else { return }
                self.childViewController.view.frame.origin.x = width * SlideMenuConstants.slideMenuOriginRatio
                self.shadowView.alpha = SlideMenuConstants.shadowAlpha
            },
            completion: { [weak self] _ in
                guard let `self` = self else { return }
                self.childViewController.didMoveToParentViewController(self)
                self.slideMenuState = .open
            }
        )
    }
        
}
