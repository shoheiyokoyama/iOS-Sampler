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
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? UICollectionViewController,
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? UICollectionViewController
             else { return }
        let containerView = transitionContext.containerView
        
        
        
        let alphaView = UIView(frame: transitionContext.finalFrame(for: toVC))
        alphaView.backgroundColor = UIColor.white
        containerView.addSubview(alphaView)
        
//        let imageView = fromCell!.articleImage
        let imageView = UIImageView(image: fromCell?.articleImage.image)
        
        if goingForward {
            containerView.insertSubview(toVC.view, aboveSubview: fromVC.view)
            let indexPath = self.fromCollectionView?.indexPath(for: self.fromCell!)
            
            toVC.collectionView?.performBatchUpdates({

                toVC.collectionView?.reloadData()
                
                }, completion: { _ in
                    
                    containerView.addSubview(imageView)
                    imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    
                    let cell = toVC.collectionView?.cellForItem(at: indexPath!)
                    
                    UIView.animate(withDuration: 1,
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
            
            let indexPath = self.fromCollectionView?.indexPath(for: self.fromCell!)
            let attributes = self.fromCollectionView?.layoutAttributesForItem(at: indexPath!)
            
            print(self.fromCollectionView?.convert((attributes?.frame)!, to: self.fromCollectionView!.superview))
            print(attributes?.frame)
            
            imageView.frame = (attributes?.frame)!
            imageView.frame.origin.y += (fromVC.navigationController?.navigationBar.frame.size.height ?? 0) + 20
            containerView.addSubview(imageView)
            alphaView.alpha = 0
            
            UIView.animate(withDuration: 1,
                animations: {
                    imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

                        imageView.frame.origin.y += (toVC.navigationController?.navigationBar.frame.size.height ?? 0)
                    alphaView.alpha = 1
                },
                completion: { _ in
                                        
                    containerView.insertSubview(toVC.view, aboveSubview: fromVC.view)
                    
                    toVC.collectionView?.performBatchUpdates({
                                            
                    toVC.collectionView?.reloadData()
                                            
                                            },
                    completion: { _ in
                                                
//                toVC.collectionView?.scrollToItemAtIndexPath(indexPath!, atScrollPosition: .None, animated: false)
                                                
                // nilになる
                let cell = toVC.collectionView?.cellForItem(at: indexPath!)
                                                
                imageView.removeFromSuperview()
                alphaView.removeFromSuperview()
                                                
                transitionContext.completeTransition(true)                             
                })
            })
            
        }
        
    }
    
    fileprivate func gridLayout(_ rect: CGRect) -> UICollectionViewFlowLayout {
        let margin: CGFloat = 5
        let height: CGFloat = 150
        let rowCount: CGFloat = 3
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = margin
        layout.minimumInteritemSpacing = margin
        layout.itemSize = CGSize(width: rect.width / rowCount - (margin * (rowCount - 1) / rowCount), height: height)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: margin, right: 0)
        return layout
    }
}
