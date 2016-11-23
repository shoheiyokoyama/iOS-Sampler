//
//  ViewController.swift
//  BezierPath
//
//  Created by Shohei Yokoyama on 2016/11/23.
//  Copyright © 2016年 Shohei. All rights reserved.
//

import UIKit

enum CircleType {
    case circle, semicircle, harfSemicircle, leftSemicircle, rightSemicircle
    
    var parameter: (start: CGFloat, end: CGFloat, clockwise: Bool) {
        let π = CGFloat(M_PI)
        switch self {
        case .circle: return (0, π * 2, false)
        case .semicircle: return (0, π, false)
        case .harfSemicircle: return (0, π + (π / 2), false)
        case .leftSemicircle: return (π + (π / 2), π / 2, false)
        case .rightSemicircle: return (π + (π / 2), π / 2, true)
        }
    }
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        drawCircle(.rightSemicircle)
    }
}

extension ViewController {
    func drawCircle(_ type: CircleType) {
        let centerPoint = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        
        let path = UIBezierPath()
        path.move(to: centerPoint)
        path.addArc(withCenter: centerPoint, radius: 100, startAngle: type.parameter.start, endAngle: type.parameter.end, clockwise: type.parameter.clockwise)
        
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.orange.cgColor
        layer.path = path.cgPath
        view.layer.addSublayer(layer)
    }
}

