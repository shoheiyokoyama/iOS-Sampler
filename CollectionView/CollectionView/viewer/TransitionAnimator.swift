//
//  TransitionAnimator.swift
//  CollectionView
//
//  Created by 横山 祥平 on 2016/07/26.
//  Copyright © 2016年 Shohei Yokoyama. All rights reserved.
//

import UIKit

final class TransitionAnimator: NSObject {
    let duration = 1.0
    var operation = UINavigationControllerOperation.Push
    var goingForward = true
    
    static let sharedInstance = TransitionAnimator()
    
    var sourceTransition: UIViewController?
    var destinationTransition: UIViewController?
    
    var toImageSource: (() -> (UIImageView))?
    var fromImageSource: (() -> (UIImageView))?
    
    var toImageFrame: (() -> (CGRect))?
    var fromImageFrame: (() -> (CGRect))?
    
    var setImageHandler: ((UIImageView) -> ())?
}

extension TransitionAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let containerView = transitionContext.containerView()!
        
        let alphaView = UIView(frame: transitionContext.finalFrameForViewController(toViewController))
        containerView.addSubview(alphaView)
        
        let sourceView = toImageSource?()
        containerView.addSubview(sourceView!)
        
        if goingForward {
            UIView.animateWithDuration(0.3,
                animations: {
                    sourceView?.frame = self.toImageFrame!()
                    sourceView?.transform = CGAffineTransformMakeScale(1.02, 1.02)
                    alphaView.alpha = 0.9
                }, completion: { _ in
                    
                    UIView.animateWithDuration(0.3,
                        animations: {
                            alphaView.alpha = 0
                            sourceView!.transform = CGAffineTransformIdentity
                        }, completion: { _ in
                            sourceView!.alpha = 0
                            self.setImageHandler!(sourceView!)
                            transitionContext.completeTransition(true)
                            alphaView.removeFromSuperview()
                            sourceView?.removeFromSuperview()
                    })
            })
        }
        
    }
}
