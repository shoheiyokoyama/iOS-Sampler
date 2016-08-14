//
//  DetailCollectionViewController.swift
//  CollectionView
//
//  Created by Shohei Yokoyama on 2016/08/14.
//  Copyright © 2016年 Shohei Yokoyama. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ViewerCollectionViewCell"

final class DetailCollectionViewController: UICollectionViewController {
    
    var selectedIndexPath: NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
        configureCollectionView()
//        useLayoutToLayoutNavigationTransitions = true
//        navigationController?.delegate = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    private var flowLayout: UICollectionViewFlowLayout {
        let margin: CGFloat = 5
        let height: CGFloat = 150
        let rowCount: CGFloat = 3

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Vertical
        layout.minimumLineSpacing = margin
        layout.minimumInteritemSpacing = margin
        layout.itemSize = CGSize(width: view.frame.width / rowCount - (margin * (rowCount - 1) / rowCount), height: height)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: margin, right: 0)
        return layout
    }
    
    private func registerCell() {
        let nib = UINib(nibName: reuseIdentifier, bundle: nil)
        collectionView!.registerNib(nib, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    private func configureCollectionView() {
        collectionView?.collectionViewLayout = flowLayout
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDelegate

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


// MARK: UICollectionViewDataSources

extension DetailCollectionViewController {
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as? ViewerCollectionViewCell else { return UICollectionViewCell() }
        cell.indexLabel.text = "\(indexPath.row)"
        return cell
    }
}

// MARK: UICollectionViewDelegate

extension DetailCollectionViewController {
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        
        selectedIndexPath = indexPath
        self.navigationController?.popViewControllerAnimated(true)
    }
}
