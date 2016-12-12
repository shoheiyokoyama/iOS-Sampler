//
//  MyHeaderView.swift
//  TableView
//
//  Created by 横山祥平 on 2016/12/12.
//  Copyright © 2016年 Shohei. All rights reserved.
//

import UIKit

class MyHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = UIColor.cyan
    }

}
