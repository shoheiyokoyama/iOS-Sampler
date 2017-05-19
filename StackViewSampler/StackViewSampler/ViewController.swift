//
//  ViewController.swift
//  StackViewSampler
//
//  Created by 横山 祥平 on 2017/05/19.
//  Copyright © 2017年 InstagramTeam12. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var stackView: UIStackView!
    
    var size = CGSize(width: 240, height: 128)
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        let view1 = UIView()
        //view1.frame.size = size
        view1.backgroundColor = UIColor.red
        stackView.addArrangedSubview(view1)
        
        let view2 = UIView()
        //view2.frame.size = size
        view2.backgroundColor = UIColor.yellow
        stackView.addArrangedSubview(view2)
    }

}

