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

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func valueChanged(_ slider: UISlider) {
        let degree = CGFloat(slider.value) * 180
        let radian = degree * CGFloat.pi / 180
        imageView.layer.transform = CATransform3DMakeRotation(radian, 0, 1, 0)
        //setAnchorPoint(anchorPoint: CGPoint(x: 0, y: 0.5), forView: imageView)
        setAnchorPoint(anchorPoint: CGPoint(x: 1, y: 0.5), forView: imageView)
    }
    
    //http://qiita.com/usagimaru/items/b085d13ac47707ce5c69
    func setAnchorPoint(anchorPoint: CGPoint, forView view: UIView) {
        var newPoint = CGPoint(x: view.bounds.size.width * anchorPoint.x, y: view.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x: view.bounds.size.width * view.layer.anchorPoint.x, y: view.bounds.size.height * view.layer.anchorPoint.y)
        
        
        newPoint = newPoint.applying(view.transform)
        oldPoint = oldPoint.applying(view.transform)
        
        var position = view.layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        view.layer.position = position
        view.layer.anchorPoint = anchorPoint
    }
}

