//
//  ViewController.swift
//  LocalJSON
//
//  Created by 横山 祥平 on 2017/04/25.
//  Copyright © 2017年 Shohei Yokoyama. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadJSON()
    }


    func loadJSON() {
        guard let file = Bundle.main.url(forResource: "emoji", withExtension: "json"),
            let data = try? Data(contentsOf: file),
            let json = try? JSONSerialization.jsonObject(with: data, options: []),
            let object = json as? [[String: AnyObject]] else {
                return 
        }
        
        print(object)
    }
}

