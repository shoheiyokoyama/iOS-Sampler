//
//  ViewController.swift
//  DeviceVolumeSampler
//
//  Created by 横山 祥平 on 2017/06/06.
//  Copyright © 2017年 shoheiyokoyama. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(true)
        } catch {
            
        }
        
        session.addObserver(self, forKeyPath: "outputVolume",
                                 options: NSKeyValueObservingOptions.new, context: nil)
        
        progressView.progress = session.outputVolume
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "outputVolume" {
           
            if let volume = (object as? AVAudioSession)?.outputVolume {
                progressView.progress = volume
                print(volume)
            }
        }
    }
}

