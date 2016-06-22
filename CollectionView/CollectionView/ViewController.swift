//
//  ViewController.swift
//  CollectionView
//
//  Created by 横山 祥平 on 2016/06/22.
//  Copyright © 2016年 Shohei Yokoyama. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let cellIdentifier = "CustomCollectionViewCell"
    let headerIdentifier = "CustomCollectionReusableView"

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configereCollectionViewCell()
    }
    
    private func configereCollectionViewCell() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        collectionView.registerNib(nib, forCellWithReuseIdentifier: cellIdentifier)
        
        let headerNib = UINib(nibName: headerIdentifier, bundle: nil)
        collectionView.registerNib(headerNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    }

}

extension ViewController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var cell: UICollectionReusableView = UICollectionReusableView()
        if kind == UICollectionElementKindSectionHeader {
            cell = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentifier, forIndexPath: indexPath)
            
            return cell
        }
        
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    
}