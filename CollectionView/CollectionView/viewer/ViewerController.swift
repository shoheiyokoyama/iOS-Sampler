//
//  ViewerController.swift
//  CollectionView
//
//  Created by 横山 祥平 on 2016/07/25.
//  Copyright © 2016年 Shohei Yokoyama. All rights reserved.
//

import UIKit

final class ViewerController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let identifier = "ViewerCollectionViewCell"
    
    @IBOutlet weak var bottomBarView: UIView!
    @IBOutlet weak var topBarView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    let animator = TransitionAnimator.sharedInstance
    
    var vc: BlickViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
     
        registerCell()
        configureCollectionView()
        titleLabel.text = "タイトルタイトルタイトル"
        navigationController?.delegate = self
        
        let storyboard = UIStoryboard(name: "Blick", bundle: nil)
        vc = storyboard.instantiateViewControllerWithIdentifier("Blick") as? BlickViewController
        vc!.view.setNeedsDisplay()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

private extension ViewerController {
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.pagingEnabled = true
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        layout.sectionInset = UIEdgeInsetsZero
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.collectionViewLayout = layout
    }
    
    private func registerCell() {
        let nib = UINib(nibName: identifier, bundle: nil)
        collectionView.registerNib(nib, forCellWithReuseIdentifier: identifier)
    }
    
    @IBAction func tap(sender: AnyObject) {
        navigationController?.pushViewController(vc!, animated: true)
    }
}

extension ViewerController: UINavigationControllerDelegate {
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.operation = operation
        animator.sourceTransition = fromVC
        animator.destinationTransition = toVC
        return animator
    }
}

extension ViewerController: UICollectionViewDelegate {
    
}

extension ViewerController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath)
        return cell
    }
}

extension ViewerController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: view.bounds.width, height: view.bounds.height)
    }
    
    //http://dev.classmethod.jp/smartphone/iphone/collection-view-layout-cell-snap/
//    func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, velocity: CGPoint) -> CGPoint {
//        let currentPage = collectionView.contentOffset.x / view.bounds.width
//        if fabs(velocity.x) > 0.2 {
//            let nextPage = (velocity.x > 0.0) ? ceil(currentPage) : floor(currentPage)
//            return CGPoint(x: nextPage * view.bounds.width, y: proposedContentOffset.y)
//        } else {
//            return CGPoint(x: (round(currentPage) * view.bounds.width), y: proposedContentOffset.y)
//        }
//    }
}
