//
//  SampleView.swift
//  StoryboardInstansate
//
//  Created by 横山祥平 on 2016/08/04.
//  Copyright © 2016年 Shohei. All rights reserved.
//

import UIKit

class SampleView: UIView {
    
    
    //http://qiita.com/reikubonaga/items/cb52dea471cfe1640773
    
    //コードから生成された時
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    //xibから生成　IBOutletやIBActionはロードされていない
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    //xibから生成　IBOutletやIBActionはロードされている
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
