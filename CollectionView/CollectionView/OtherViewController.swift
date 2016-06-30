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
    
    let rect = CGRect(x: 50, y: 50, width: 200, height: 440)
    
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
        collectionView.backgroundColor = UIColor.grayColor()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        collectionView.registerNib(nib, forCellWithReuseIdentifier: cellIdentifier)
        
        let margin: CGFloat = 8
        let rowNum: CGFloat = 2
        let columnNum: CGFloat = 3
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: rect.width / 2 - (margin * 3 / rowNum), height: rect.height / 3 - (margin * 4 / columnNum))
        layout.minimumLineSpacing = margin
        layout.minimumInteritemSpacing = margin
        layout.scrollDirection = .Vertical
        layout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        collectionView!.collectionViewLayout = layout
    }

}

extension OtherViewController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath)
        return cell
    }
}

extension OtherViewController: UICollectionViewDelegate {
    
}
