//
//  TransitionAnimator.swift
//  CollectionView
//
//  Created by Shohei Yokoyama on 2016/08/14.
//  Copyright © 2016年 Shohei Yokoyama. All rights reserved.
//

import UIKit

final class CollectionViewTransitionAnimator: NSObject {
    var goingForward: Bool = true
    var fromCollectionView: UICollectionView?
    var fromCell: ViewerCollectionViewCell?
    
}

extension CollectionViewTransitionAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 1
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as? UICollectionViewController,
            fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as? UICollectionViewController,
            containerView = transitionContext.containerView() else { return }
        
        containerView.addSubview(fromVC.view)
        containerView.addSubview(toVC.view)
        
        let alphaView = UIView(frame: transitionContext.finalFrameForViewController(toVC))
        alphaView.backgroundColor = UIColor.whiteColor()
        containerView.addSubview(alphaView)
        
        let sourceView = fromCell?.articleImage
//        sourceView?.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
        
        
        
        if goingForward {
            let indexPath = self.fromCollectionView?.indexPathForCell(self.fromCell!)
            toVC.collectionView?.performBatchUpdates({
                

                toVC.collectionView?.reloadData()
                
                }, completion: { _ in
                    
                    containerView.addSubview(sourceView!)
                    sourceView?.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
                    
                    let cell = toVC.collectionView?.cellForItemAtIndexPath(indexPath!)
                    
                    UIView.animateWithDuration(0.5,
                        animations: {
                            sourceView?.frame = (cell?.frame)!
                            sourceView?.frame.origin.y += (fromVC.navigationController?.navigationBar.frame.size.height ?? 0) + 20
                            alphaView.alpha = 0
                        },
                        completion: { _ in
                            sourceView?.removeFromSuperview()
                            alphaView.removeFromSuperview()
                            
                            transitionContext.completeTransition(true)
                    })
                    
            })
            
            
        } else {
            
        }
        
    }
    
    private func gridLayout(rect: CGRect) -> UICollectionViewFlowLayout {
        let margin: CGFloat = 5
        let height: CGFloat = 150
        let rowCount: CGFloat = 3
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Vertical
        layout.minimumLineSpacing = margin
        layout.minimumInteritemSpacing = margin
        layout.itemSize = CGSize(width: rect.width / rowCount - (margin * (rowCount - 1) / rowCount), height: height)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: margin, right: 0)
        return layout
    }
}
