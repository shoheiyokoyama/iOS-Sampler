//
//  PlayerView.swift
//  AVPlayerSampler
//
//  Created by 横山 祥平 on 2017/05/09.
//  Copyright © 2017年 Shohei Yokoyama. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerView: UIView {
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    var player: AVPlayer? {
        return playerLayer.player
    }
    
    var isEndlessPlay = false

    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupNotification()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        setupNotification()
    }
    
    private func setup() {
        player?.currentItem?.seek(to: kCMTimeZero)
    }
    
    func setVideoURL(_ url: URL) {
        let asset      = AVURLAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        playerLayer.player = AVPlayer(playerItem: playerItem)
    }
    
    func start() {
        player?.play()
    }
    
    func stop() {
        player?.pause()
    }
    
    func replay() {
        player?.pause()
        player?.currentItem?.seek(to: kCMTimeZero)
        player?.play()
    }
    
    func setupNotification() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { [weak self] notification in
            if self?.isEndlessPlay == true {
                self?.player?.seek(to: kCMTimeZero)
                self?.player?.play()
            }
        }
    }
}
