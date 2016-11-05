//
//  CustomController.swift
//  CollectionView
//
//  Created by 横山祥平 on 2016/08/18.
//  Copyright © 2016年 Shohei Yokoyama. All rights reserved.
//

import UIKit

class CustomController: UIViewController {
    
    let cellIdentifier = "CustomCell"

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        collectionView.registerNib(nib, forCellWithReuseIdentifier: cellIdentifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension CustomController: UICollectionViewDelegate {
    
}

extension CustomController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath)
        return cell
    }
}

extension CustomController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let margin: CGFloat = 5
        let height: CGFloat = 150
        
        let rowCount: CGFloat = 3
        return CGSize(width: view.frame.width / rowCount - (margin * (rowCount - 1) / rowCount), height: height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let margin: CGFloat = 5
        return UIEdgeInsets(top: 0, left: 0, bottom: margin, right: 0)
    }
}


