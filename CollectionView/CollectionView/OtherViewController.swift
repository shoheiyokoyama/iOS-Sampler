//
//  OtherViewController.swift
//  CollectionView
//
//  Created by 横山祥平 on 2016/06/29.
//  Copyright © 2016年 Shohei Yokoyama. All rights reserved.
//

import UIKit

class OtherViewController: UIViewController {
    let cellIdentifier = "OtherCollectionViewCell"

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        configereCollectionViewCell()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    private func configereCollectionViewCell() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        collectionView.registerNib(nib, forCellWithReuseIdentifier: cellIdentifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 50)
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .Vertical
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        collectionView!.collectionViewLayout = layout
    }

}

extension OtherViewController: UICollectionViewDataSource {
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
}

extension OtherViewController: UICollectionViewDelegate {
    
}
