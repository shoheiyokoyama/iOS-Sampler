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
    var operation = UINavigationControllerOperation.push
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
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let containerView = transitionContext.containerView
        
        let alphaView = UIView(frame: transitionContext.finalFrame(for: toViewController))
        containerView.addSubview(alphaView)
        
        let sourceView = toImageSource?()
        containerView.addSubview(sourceView!)
        
        if goingForward {
            UIView.animate(withDuration: 0.3,
                animations: {
                    sourceView?.frame = self.toImageFrame!()
                    sourceView?.transform = CGAffineTransform(scaleX: 1.02, y: 1.02)
                    alphaView.alpha = 0.9
                }, completion: { _ in
                    
                    UIView.animate(withDuration: 0.3,
                        animations: {
                            alphaView.alpha = 0
                            sourceView!.transform = CGAffineTransform.identity
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
