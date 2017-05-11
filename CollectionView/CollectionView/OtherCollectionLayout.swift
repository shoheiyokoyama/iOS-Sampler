//
//  OtherCollectionLayout.swift
//  CollectionView
//
//  Created by 横山祥平 on 2016/06/29.
//  Copyright © 2016年 Shohei Yokoyama. All rights reserved.
//

import UIKit

class OtherCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func awakeFromNib() {
        itemSize = CGSize(width: 50, height: 50);
        minimumLineSpacing = 40
        scrollDirection = .vertical;
        sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    }
}
