//
//  VideoViewController.swift
//  CustomCameraSampler
//
//  Created by 横山 祥平 on 2017/05/22.
//  Copyright © 2017年 Shohei Yokoyama. All rights reserved.
//

import UIKit
import AVFoundation
import AssetsLibrary

//https://sites.google.com/a/gclue.jp/swift-docs/ni-yinki100-ios/3-avfoundation/003-dong-huano-cuo-ying
//http://qiita.com/takecian/items/2cee0f958c8bed00a69a

// compress
//http://stackoverflow.com/questions/40470637/swift-compressing-video-files
final class VideoViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var videoView: UIView!
    
    let session = AVCaptureSession()
    let videoDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    let audioDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio)
    
    //出力先
    let fileOutput = AVCaptureMovieFileOutput()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    private func configure() {
        
        
        
        guard let videoInput = try? AVCaptureDeviceInput(device: videoDevice),
            let audioInput = try? AVCaptureDeviceInput(device: audioDevice) else {
            return
        }
        
        session.addInput(videoInput)
        session.addInput(audioInput)
        
        session.addOutput(fileOutput)
        session.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)!
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer.connection.videoOrientation = .portrait
        previewLayer.frame = view.bounds
        videoView.layer.addSublayer(previewLayer)
    }
    
    @IBAction func touchUpInside(_ sender: Any) {
        print("touchUpInside")
         fileOutput.stopRecording()
    }
    
    @IBAction func buttonTouchDown(_ sender: Any) {
        print("buttonTouchDown")
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0] as String
        let filePath : String = "\(documentsDirectory)/temp.mov"
        let url = URL(fileURLWithPath: filePath)
        fileOutput.startRecording(toOutputFileURL: url, recordingDelegate: self)
    }
}

extension VideoViewController: AVCaptureFileOutputRecordingDelegate {
    func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
        //
    }
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        //let assetsLib = ALAssetsLibrary()
        //assetsLib.writeVideoAtPath(toSavedPhotosAlbum: outputFileURL, completionBlock: nil)
        
        if let data = try? Data(contentsOf: outputFileURL) {
            print(data)
            print("File size before compression: \(Double(data.count / 1048576)) mb")
            compressVideo(outputFileURL: outputFileURL)
        }
    }
    
    //http://stackoverflow.com/questions/40470637/swift-compressing-video-files
    func compressVideo(outputFileURL: URL) {
        let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".m4v")
        
        let urlAsset = AVURLAsset(url: outputFileURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetMediumQuality) else {
            return
        }
        
        exportSession.outputURL = compressedURL
        exportSession.outputFileType = AVFileTypeQuickTimeMovie
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously { () -> Void in
            switch exportSession.status {
            case .unknown:
                break
            case .waiting:
                break
            case .exporting:
                break
            case .completed:
                if let compressedData = try? Data(contentsOf: compressedURL) {
                    print("File size after compression: \(Double(compressedData.count / 1048576)) mb")
                }
                
            case .failed:
                break
            case .cancelled:
                break
            }

        }
    }
}
//resize
//https://stackoverflow.com/questions/35402633/swift-video-resizer-avasset

//http://source.hatenadiary.jp/entry/2014/03/18/145436

