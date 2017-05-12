//
//  CustomCell.swift
//  CollectionView
//
//  Created by 横山祥平 on 2016/08/18.
//  Copyright © 2016年 Shohei Yokoyama. All rights reserved.
//

import UIKit

class CustomCell: UICollectionViewCell {

    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    func configure() {
        let needsChangeHeihgt = arc4random_uniform(4) == 0
        viewHeight.constant = needsChangeHeihgt ? 100 : 200
    }
}
