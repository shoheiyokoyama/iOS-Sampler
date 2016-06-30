//
//  ViewController.swift
//  StoryboardInstansate
//
//  Created by 横山祥平 on 2016/06/30.
//  Copyright © 2016年 Shohei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func tapButton(sender: AnyObject) {
        //ファイル名が同じ場合
        //storyboardのstoryboard IDをFirstViewControllerにしないと落ちる。この場合、クリーン、シュミレータのアプリ消さないとエラー消えない
        let storyboard = UIStoryboard(name: "FirstViewController", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("FirstViewController") as! FirstViewController
        presentViewController(vc, animated: true, completion: nil)
    }
}

