//
//  ViewController.swift
//  CustomCameraSampler
//
//  Created by 横山 祥平 on 2017/05/10.
//  Copyright © 2017年 Shohei Yokoyama. All rights reserved.
//

import UIKit
import AVFoundation

//http://qiita.com/tfutada/items/3e415cbe176d6f801b1d

class ViewController: UIViewController {
    
    var captureSesssion = AVCaptureSession()
    var stillImageOutput = AVCapturePhotoOutput()
    var previewLayer: AVCaptureVideoPreviewLayer?

    @IBOutlet weak var cameraView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        
        captureSesssion.sessionPreset = AVCaptureSessionPreset1920x1080 // 解像度の設定
        
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        guard let input = try? AVCaptureDeviceInput(device: device),
            captureSesssion.canAddInput(input),
            captureSesssion.canAddOutput(stillImageOutput) else {
            return
        }
        
        captureSesssion.addInput(input)
        captureSesssion.addOutput(stillImageOutput)
        captureSesssion.startRunning() // カメラ起動
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSesssion)
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspect // アスペクトフィット
        previewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.portrait // カメラの向き
        
        cameraView.layer.addSublayer(previewLayer!)
        
        // ビューのサイズの調整
        previewLayer?.position = CGPoint(x: cameraView.frame.width / 2, y: cameraView.frame.height / 2)
        previewLayer?.bounds = cameraView.frame
    }
    
    
    @IBAction func tapButton(_ sender: Any) {
        let settingsForMonitoring = AVCapturePhotoSettings()
        settingsForMonitoring.flashMode = .auto
        settingsForMonitoring.isAutoStillImageStabilizationEnabled = true
        settingsForMonitoring.isHighResolutionPhotoEnabled = false
        // シャッターを切る
        stillImageOutput.capturePhoto(with: settingsForMonitoring, delegate: self)
    }
}

extension ViewController: AVCapturePhotoCaptureDelegate {
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if let photoSampleBuffer = photoSampleBuffer {
            // JPEG形式で画像データを取得
            let photoData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
            let image = UIImage(data: photoData!)
            print(image)
        }
    }
}

