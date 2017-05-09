//
//  PlayerViewController.swift
//  AVPlayerSampler
//
//  Created by 横山 祥平 on 2017/05/09.
//  Copyright © 2017年 Shohei Yokoyama. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class PlayerViewController: UIViewController {
    
    var sampleMovieURL: URL {
        return URL(string: "http://techslides.com/demos/sample-videos/small.mp4")!
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let player = AVPlayer(url: sampleMovieURL)
        let controller = AVPlayerViewController()
        controller.player = player
        controller.view.frame = view.bounds
        addChildViewController(controller)
        view.addSubview(controller.view)
        player.play()
    }
}
