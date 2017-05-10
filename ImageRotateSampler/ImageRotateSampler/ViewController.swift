//
//  ViewController.swift
//  ImageRotateSampler
//
//  Created by 横山 祥平 on 2017/05/10.
//  Copyright © 2017年 Shohei Yokoyama. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //https://gist.github.com/ffried/0cbd6366bb9cf6fc0208
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var slider: UISlider!
    
    var originalImage = UIImage(named: "sample")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //imageView.image = imageView.image?.imageRotatedByDegrees(degrees: -80)
    }
    
    @IBAction func changeSliderValue(_ sender: Any) {
        let degree = ((sender as? UISlider)?.value ?? 0) * 180
        
        //imageView.image = originalImage?.imageRotatedByDegrees(degrees: CGFloat(degree))
        imageView.image = originalImage?.rotate(angle: CGFloat(degree))
    }
}

extension UIImage {
    
    //sample 1
    func imageRotatedByDegrees(degrees: CGFloat) -> UIImage {
        let radiansToDegrees: (CGFloat) -> CGFloat = {
            return $0 * (180 / CGFloat.pi)
        }
        
        let degreesToRadians: (CGFloat) -> CGFloat = {
            return $0 / (180 * CGFloat.pi)
        }
        
        // calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox = UIView(frame: CGRect(origin: .zero, size: size))
        let t = CGAffineTransform(rotationAngle: degreesToRadians(degrees))
        rotatedViewBox.transform = t
        //let rotatedSize = rotatedViewBox.frame.size
        let rotatedSize = self.size
        
        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()
        
        // Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap!.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        
        //   // Rotate the image context
        bitmap!.rotate(by: degreesToRadians(degrees))
        
        // Now, draw the rotated/scaled image into the context
        bitmap!.scaleBy(x: 1, y: -1)
        
        bitmap!.draw(cgImage!, in: CGRect(x: -size.width / 2, y:  -size.height / 2, width: size.width, height: size.height))
        //CGContextDrawImage(bitmap, CGRectMake(-size.width / 2, -size.height / 2, size.width, size.height), CGImage)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    // sample2
    func rotate(angle: CGFloat) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(CGSize(width: size.width, height: self.size.height), false, 0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        
        context.translateBy(x: size.width/2, y: size.height/2)
        
        context.scaleBy(x: 1, y: -1)
        
        let radian: CGFloat = (-angle) * CGFloat.pi / 180.0
        context.rotate(by: radian)
        
        context.draw(cgImage!, in: CGRect(x: -size.width / 2, y:  -size.height / 2, width: size.width, height: size.height))
        
        let rotatedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return rotatedImage
    }
}

