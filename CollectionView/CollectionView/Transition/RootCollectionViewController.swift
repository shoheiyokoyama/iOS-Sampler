//
//  RootCollectionViewController.swift
//  CollectionView
//
//  Created by Shohei Yokoyama on 2016/08/14.
//  Copyright © 2016年 Shohei Yokoyama. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ViewerCollectionViewCell"

final class RootCollectionViewController: UICollectionViewController {
    
    var selectedIndexPath: NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
        configureCollectionView()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        configureCollectionView()
        collectionView?.reloadData()
    }

    private var flowLayout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: view.bounds.width, height: view.bounds.height)
        layout.sectionInset = UIEdgeInsetsZero
        return layout
    }
    
    private func registerCell() {
        let nib = UINib(nibName: reuseIdentifier, bundle: nil)
        collectionView!.registerNib(nib, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    private func configureCollectionView() {
        navigationController?.delegate = self
        collectionView?.pagingEnabled = true
        collectionView?.collectionViewLayout = flowLayout
    }

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}

extension RootCollectionViewController: UINavigationControllerDelegate {
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .Push && fromVC == self {
            let animator = CollectionViewTransitionAnimator()
            animator.fromCollectionView = collectionView
            animator.goingForward = true
            if let cell = collectionView?.cellForItemAtIndexPath(selectedIndexPath) as? ViewerCollectionViewCell {
                animator.fromCell = cell
            }
            return animator
        } else if operation == .Pop && toVC == self {
            
            let animator = CollectionViewTransitionAnimator()
            
            guard let vc = fromVC as? DetailCollectionViewController,
                cell = vc.collectionView?.cellForItemAtIndexPath(vc.selectedIndexPath) as? ViewerCollectionViewCell else {return nil}
            animator.fromCollectionView = vc.collectionView
            animator.fromCell = cell
            animator.goingForward = false
            return animator
//            return nil
            
        } else {
            return nil
        }
    }
    
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        if let vc = viewController as? DetailCollectionViewController {
            vc.collectionView?.dataSource = vc
            vc.collectionView?.delegate = vc
        } else if let vc = viewController as? RootCollectionViewController {
            vc.collectionView?.dataSource = self
            vc.collectionView?.delegate = self
        }
    }
}

// MARK: UICollectionViewDataSource

extension RootCollectionViewController {
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as? ViewerCollectionViewCell else { return UICollectionViewCell() }
//        cell.articleImage.image = UIImage(named: "article_image")
        cell.indexLabel.text = "\(indexPath.row)"
        return cell
    }
}

// MARK: UICollectionViewDelegate

extension RootCollectionViewController {
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        guard  let vc = storyboard?.instantiateViewControllerWithIdentifier("DetailCollectionViewController") as? UICollectionViewController else { return }
        selectedIndexPath = indexPath
        navigationController?.pushViewController(vc, animated: true)
    }
}
