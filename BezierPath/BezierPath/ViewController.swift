//
//  ViewController.swift
//  BezierPath
//
//  Created by Shohei Yokoyama on 2016/11/23.
//  Copyright © 2016年 Shohei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let parameter: (start: CGFloat, end: CGFloat)
        parameter = (0, CGFloat(M_PI))
        
        drawCircle(startAngle: parameter.start, endAngle: parameter.end)
    }
}

extension ViewController {
    func drawCircle(startAngle: CGFloat, endAngle: CGFloat, radius: CGFloat = 100) {
        let centerPoint = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        
        let path = UIBezierPath()
        path.move(to: centerPoint)
        path.addArc(withCenter: centerPoint, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.orange.cgColor
        layer.path = path.cgPath
        view.layer.addSublayer(layer)
    }
}

