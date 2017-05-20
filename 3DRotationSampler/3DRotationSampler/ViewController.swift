//
//  ViewController.swift
//  3DRotationSampler
//
//  Created by 横山 祥平 on 2017/05/20.
//  Copyright © 2017年 InstagramTeam12. All rights reserved.
//

import UIKit

//http://stackoverflow.com/questions/35446457/understanding-catransform3drotate-catransform3dmakerotation

/*
 θ = θ * π / 180
 
 e.g) 90
 
 90 * π / 180
 = π / 2
*/

class ViewController: UIViewController {

    @IBOutlet weak var viewTrailing: NSLayoutConstraint!
    @IBOutlet weak var viewLeading: NSLayoutConstraint!
    @IBOutlet weak var slider: UISlider!
    //Autolayoutのimageview
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contnetView: UIView!
    
    let codeImage: UIImageView = UIImageView(image: UIImage(named: "Sample")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        codeImage.frame = CGRect(x: 0, y: 0, width: 240, height: 240)
        contnetView.addSubview(codeImage)
    }
    
    @IBAction func valueChanged(_ slider: UISlider) {
        let degree = CGFloat(slider.value) * 90
        let radian = degree * CGFloat.pi / 180
        codeImage.layer.transform = CATransform3DMakeRotation(radian, 0, 1, 0)
        if slider.value > 0 {
            codeImage.setRelativeAnchorPoint(CGPoint(x: 1, y: 0.5))
        } else {
            codeImage.setRelativeAnchorPoint(CGPoint(x: 0, y: 0.5))
        }
        
        //content viewを動かした場合、autolayoutを設定しているとlayoutがバグる
        let leading: CGFloat = 67
        if slider.value < 0 {
            viewLeading.constant = leading - CGFloat(slider.value) * leading
        }
    }
}

//http://qiita.com/usagimaru/items/b085d13ac47707ce5c69
extension UIView {
    func setRelativeAnchorPoint(_ point: CGPoint) {
        var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y)
        
        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)
        
        var position = layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        layer.position    = position
        layer.anchorPoint = point
    }
}

