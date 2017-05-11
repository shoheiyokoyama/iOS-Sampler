//
//  CustomCollectionViewFlowLayout.swift
//  CollectionView
//
//  Created by 横山 祥平 on 2016/06/22.
//  Copyright © 2016年 Shohei Yokoyama. All rights reserved.
//

import UIKit

class CustomCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func awakeFromNib() {
        itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 30)
        minimumLineSpacing = 40;
        scrollDirection = .vertical;
        
        sectionInset = UIEdgeInsetsMake(30, 0, 0, 0);
    }
}
