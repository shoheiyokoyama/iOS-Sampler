//
//  AnimationCollectionViewCell.swift
//  CollectionView
//
//  Created by 横山 祥平 on 2017/06/07.
//  Copyright © 2017年 Shohei Yokoyama. All rights reserved.
//

import UIKit

class AnimationCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var shadowView: UIView! {
        didSet {
            shadowView.backgroundColor = UIColor.black
        }
    }
    @IBOutlet weak var debugLabel: UILabel!
    @IBOutlet weak var pictureImageview: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()

        setAnchorPoint(CGPoint(x: 0.5, y: 0.5))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
