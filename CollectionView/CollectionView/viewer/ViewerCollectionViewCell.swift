//
//  ViewerCollectionViewCell.swift
//  CollectionView
//
//  Created by 横山 祥平 on 2016/07/25.
//  Copyright © 2016年 Shohei Yokoyama. All rights reserved.
//

import UIKit

final class ViewerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var indexLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
