//
//  ViewController.swift
//  GCD
//
//  Created by Shohei Yokoyama on 2016/11/05.
//  Copyright © 2016年 Shohei. All rights reserved.
//

import UIKit

/*
 - [Swift GCD入門](http://qiita.com/ShoichiKuraoka/items/bb2a280688d29de3ff18)
 - [Swift3のGCD周りのまとめ](http://qiita.com/marty-suzuki/items/f0547e40dc09e790328f)
 - [並列プログラミングガイド](https://developer.apple.com/jp/documentation/ConcurrencyProgrammingGuide.pdf)
 - [Concurrent Programming With GCD in Swift 3](https://developer.apple.com/videos/play/wwdc2016/720/)
 - [【iPhoneアプリ】これを使えるようにならないと「マルチスレッド」について　概要編](http://kassans.hatenablog.com/entry/2014/03/13/125332)
 - [GCD のディスパッチセマフォを活用する (Objective-C〜Swift 3 対応)](https://blog.ymyzk.com/2015/08/gcd-grand-central-dispatch-semaphore/)
 - [[Swift 3] Swift 3時代のGCDの基本的な使い方](http://dev.classmethod.jp/smartphone/iphone/swift-3-how-to-use-gcd-api-1/)
 */


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainQueue = DispatchQueue.main
        let globalQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.default)
        globalQueue.async {
            print("Hi")
        }
        mainQueue.async {
            print("Hi")
        }
    }
}

