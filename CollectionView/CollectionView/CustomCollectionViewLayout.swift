//
//  CustomCollectionViewLayout.swift
//  CollectionView
//
//  Created by 横山祥平 on 2016/08/17.
//  Copyright © 2016年 Shohei Yokoyama. All rights reserved.
//

import UIKit

class CustomCollectionViewLayout: UICollectionViewLayout {
    override var collectionViewContentSize : CGSize {
        return CGSize(width: UIScreen.main.bounds.width * 2, height: UIScreen.main.bounds.height * 2)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        //
        return [UICollectionViewLayoutAttributes()]
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return UICollectionViewLayoutAttributes()
    }
    
    
}
