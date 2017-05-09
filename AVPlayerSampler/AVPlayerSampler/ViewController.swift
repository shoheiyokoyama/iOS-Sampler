//
//  ViewController.swift
//  AVPlayerSampler
//
//  Created by 横山 祥平 on 2017/05/09.
//  Copyright © 2017年 Shohei Yokoyama. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var playerView: PlayerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = Bundle.main.path(forResource: "waterfall", ofType: "mp4") ?? ""
        let url = URL(fileURLWithPath: urlString)
        playerView.setVideoURL(url)
    }
    
    @IBAction func stop(_ sender: Any) {
        playerView.stop()
    }
    
    @IBAction func replay(_ sender: Any) {
        playerView.replay()
    }
    
    
    @IBAction func play(_ sender: Any) {
        playerView.start()
    }
}

