//
//  BlickViewController.swift
//  CollectionView
//
//  Created by 横山 祥平 on 2016/07/25.
//  Copyright © 2016年 Shohei Yokoyama. All rights reserved.
//

import UIKit

final class BlickViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let identifier = "BlickCollectionViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()
        registerCell()
    }
}

private extension BlickViewController {
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Vertical
        
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        collectionView.collectionViewLayout = layout
        
        
        navigationController?.navigationBarHidden = false
    }
    
    private func registerCell() {
        let nib = UINib(nibName: identifier, bundle: nil)
        collectionView.registerNib(nib, forCellWithReuseIdentifier: identifier)
    }
}

extension BlickViewController: UICollectionViewDelegate {
    
}

extension BlickViewController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath)
        return cell
    }
}

extension BlickViewController: UICollectionViewDelegateFlowLayout {
    
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

