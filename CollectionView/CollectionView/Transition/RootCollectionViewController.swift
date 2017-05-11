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
    
    var selectedIndexPath: IndexPath = IndexPath(row: 0, section: 0)

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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        configureCollectionView()
        collectionView?.reloadData()
    }

    fileprivate var flowLayout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: view.bounds.width, height: view.bounds.height)
        layout.sectionInset = UIEdgeInsets.zero
        return layout
    }
    
    fileprivate func registerCell() {
        let nib = UINib(nibName: reuseIdentifier, bundle: nil)
        collectionView!.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    fileprivate func configureCollectionView() {
        navigationController?.delegate = self
        collectionView?.isPagingEnabled = true
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
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .push && fromVC == self {
            let animator = CollectionViewTransitionAnimator()
            animator.fromCollectionView = collectionView
            animator.goingForward = true
            if let cell = collectionView?.cellForItem(at: selectedIndexPath) as? ViewerCollectionViewCell {
                animator.fromCell = cell
            }
            return animator
        } else if operation == .pop && toVC == self {
            
            let animator = CollectionViewTransitionAnimator()
            
            guard let vc = fromVC as? DetailCollectionViewController,
                let cell = vc.collectionView?.cellForItem(at: vc.selectedIndexPath as IndexPath) as? ViewerCollectionViewCell else {return nil}
            animator.fromCollectionView = vc.collectionView
            animator.fromCell = cell
            animator.goingForward = false
            return animator
//            return nil
            
        } else {
            return nil
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
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
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ViewerCollectionViewCell else { return UICollectionViewCell() }
//        cell.articleImage.image = UIImage(named: "article_image")
        cell.indexLabel.text = "\(indexPath.row)"
        return cell
    }
}

// MARK: UICollectionViewDelegate

extension RootCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        guard  let vc = storyboard?.instantiateViewController(withIdentifier: "DetailCollectionViewController") as? UICollectionViewController else { return }
        selectedIndexPath = indexPath
        navigationController?.pushViewController(vc, animated: true)
    }
}
