//
//  CustomCollectionViewLayout.swift
//  CollectionView
//
//  Created by 横山祥平 on 2016/08/17.
//  Copyright © 2016年 Shohei Yokoyama. All rights reserved.
//

import UIKit

class CustomCollectionViewLayout: UICollectionViewLayout {
    override func collectionViewContentSize() -> CGSize {
        return CGSize(width: UIScreen.mainScreen().bounds.width * 2, height: UIScreen.mainScreen().bounds.height * 2)
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        //
        return [UICollectionViewLayoutAttributes()]
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return UICollectionViewLayoutAttributes()
    }
    
    
}
