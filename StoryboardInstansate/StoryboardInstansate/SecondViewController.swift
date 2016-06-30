//
//  SecondViewController.swift
//  StoryboardInstansate
//
//  Created by 横山祥平 on 2016/07/01.
//  Copyright © 2016年 Shohei. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func tapButton(sender: AnyObject) {
        
        let vc = UIStoryboard.instantiateB(ThirdViewController.self)
        presentViewController(vc, animated: true, completion: nil)
    }
}
