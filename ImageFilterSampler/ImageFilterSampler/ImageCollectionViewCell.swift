//
//  ImageCollectionViewCell.swift
//  ImageFilterSampler
//
//  Created by 横山 祥平 on 2017/05/09.
//  Copyright © 2017年 Shohei Yokoyama. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var contentImageView: UIImageView! {
        didSet {
            originnalImage = contentImageView.image
        }
    }
    
    var originnalImage: UIImage?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

}
