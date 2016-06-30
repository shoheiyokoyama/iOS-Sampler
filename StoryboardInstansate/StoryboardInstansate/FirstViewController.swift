//
//  FirstViewController.swift
//  StoryboardInstansate
//
//  Created by 横山祥平 on 2016/06/30.
//  Copyright © 2016年 Shohei. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func tapButton(sender: AnyObject) {
        //nameはstoryboardのファイル名と同じでなくてはならない
        let storyboard = UIStoryboard(name: "Second", bundle: nil)
        //instantiateViewControllerWithIdentifierの引数はnameはstoryboardのstoryboard IDと同じでなくてはならない
        let vc = storyboard.instantiateViewControllerWithIdentifier("Seconda") as! SecondViewController
        presentViewController(vc, animated: true, completion: nil)
    }
}
