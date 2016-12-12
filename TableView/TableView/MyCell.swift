//
//  MyCell.swift
//  TableView
//
//  Created by 横山祥平 on 2016/12/12.
//  Copyright © 2016年 Shohei. All rights reserved.
//

import UIKit

class MyCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.blue
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
