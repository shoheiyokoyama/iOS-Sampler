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
        
        containerView.insertSubview(toVC.view, aboveSubview: fromVC.view)
        
        let alphaView = UIView(frame: transitionContext.finalFrameForViewController(toVC))
        alphaView.backgroundColor = UIColor.whiteColor()
//        containerView.addSubview(alphaView)
        
//        let imageView = fromCell!.articleImage
        let imageView = UIImageView(image: fromCell?.articleImage.image)
        
        if goingForward {
            
            let indexPath = self.fromCollectionView?.indexPathForCell(self.fromCell!)
            
            toVC.collectionView?.performBatchUpdates({

                toVC.collectionView?.reloadData()
                
                }, completion: { _ in
                    
                    containerView.addSubview(imageView)
                    imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
                    
                    let cell = toVC.collectionView?.cellForItemAtIndexPath(indexPath!)
                    
                    UIView.animateWithDuration(1,
                        animations: {
                            imageView.frame = (cell?.frame)!
                            imageView.frame.origin.y += (fromVC.navigationController?.navigationBar.frame.size.height ?? 0) + 20
                            alphaView.alpha = 0
                        },
                        completion: { _ in
                            imageView.removeFromSuperview()
                            alphaView.removeFromSuperview()
                            
                            transitionContext.completeTransition(true)
                    })
                    
            })
 
            
        } else {
            
            let indexPath = self.fromCollectionView?.indexPathForCell(self.fromCell!)
            let attributes = self.fromCollectionView?.layoutAttributesForItemAtIndexPath(indexPath!)
            
            print(self.fromCollectionView?.convertRect((attributes?.frame)!, toView: self.fromCollectionView!.superview))
            print(attributes?.frame)
            
            imageView.frame = (attributes?.frame)!
            imageView.frame.origin.y += (fromVC.navigationController?.navigationBar.frame.size.height ?? 0) + 20
            containerView.addSubview(imageView)
            
            toVC.collectionView?.performBatchUpdates({
            
                toVC.collectionView?.reloadData()
                
            },
            completion: { _ in
                
                toVC.collectionView?.scrollToItemAtIndexPath(indexPath!, atScrollPosition: .None, animated: false)
                
                // nilになる
                let cell = toVC.collectionView?.cellForItemAtIndexPath(indexPath!)
                
                UIView.animateWithDuration(1,
                    animations: {
                        imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
                        
//                        imageView.frame = (cell?.frame)!
//                        imageView.frame.origin.y += (toVC.navigationController?.navigationBar.frame.size.height ?? 0) + 20
                        imageView.frame.origin.y += (toVC.navigationController?.navigationBar.frame.size.height ?? 0)
                        alphaView.alpha = 0
                    },
                    completion: { _ in
                        imageView.removeFromSuperview()
                        alphaView.removeFromSuperview()
                        
                        transitionContext.completeTransition(true)
                })
                
                
            })

            
            
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
