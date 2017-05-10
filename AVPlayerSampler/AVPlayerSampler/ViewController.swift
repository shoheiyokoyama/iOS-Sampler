//
//  ViewController.swift
//  AVPlayerSampler
//
//  Created by 横山 祥平 on 2017/05/09.
//  Copyright © 2017年 Shohei Yokoyama. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var playerView: PlayerView!
    
    var localMovieURL: URL {
        let urlString = Bundle.main.path(forResource: "waterfall", ofType: "mp4") ?? ""
        return URL(fileURLWithPath: urlString)
    }
    
    var sampleMovieURL: URL {
        return URL(string: "https://storage.googleapis.com/instavideo/waterfall.mp4")!
    }

    //sample video
    //http://techslides.com/sample-webm-ogg-and-mp4-video-files-for-html5
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerView.setVideoURL(sampleMovieURL)
        playerView.player?.play()
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

