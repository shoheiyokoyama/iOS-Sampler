//
//  3DAnimationViewController.swift
//  CollectionView
//
//  Created by 横山 祥平 on 2017/06/07.
//  Copyright © 2017年 Shohei Yokoyama. All rights reserved.
//

import UIKit

class AnimationViewController: UIViewController {

    @IBOutlet weak var collectionView: CustomCollectionView!
    
    let cellIdentifier = "AnimationCollectionViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.addObserver()
    }
}

//Gemini
// delegate pattern
//
// - animation enabled
protocol AnimationProtocol: UICollectionViewDelegate {
    
}

extension AnimationProtocol {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("aaa")
    }
}

enum ShadowEffect {
    case next, previous, `default`, none
}

enum Effect {
    case `default`, custom, scale
}

class CustomCollectionView: UICollectionView {
    
    var shadowEffetct: ShadowEffect = .none
    var effect: Effect = .custom
    enum KeyPath: String {
        case contentOffset
    }
    
    deinit {
        removeObserver(self, forKeyPath: "\(KeyPath.contentOffset)")
    }
    
    func addObserver() {
        addObserver(self, forKeyPath: "\(KeyPath.contentOffset)", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "\(KeyPath.contentOffset)" {
            move()
        }
    }
    
    func move() {
        print("Custom Gesture")
        
        let middleX = frame.width / 2
        visibleCells.flatMap { $0 as? AnimationCollectionViewCell }
            .forEach { [weak self] cell in
                guard let me = self else { return }
                let convertedFrame = me.convert(cell.frame, to: me.superview)
                let distance = convertedFrame.midX - middleX //右方向が+
                let ratio = distance / me.frame.width
                
                switch me.shadowEffetct {
                case .next:
                    cell.shadowView.alpha = distance > 0 ? ratio : 0
                case .previous:
                    cell.shadowView.alpha = distance < 0 ? abs(ratio) : 0
                case .default:
                    cell.shadowView.alpha = abs(ratio)
                case .none:
                    cell.shadowView.alpha = 0
                }
                
                
                
                cell.debugLabel.text = String(format: "%.2f", ratio)

                var identity = CATransform3DIdentity
                identity.m34 = 1 / 1000
                
                switch me.effect {
                case .default:
                    
                    if distance > 0 {
                        cell.setAnchorPoint(CGPoint(x: 0, y: 0.5))
                    } else {
                        cell.setAnchorPoint(CGPoint(x: 1, y: 0.5))
                    }
                    
                    let degree: CGFloat = ratio * -90
                    let radian = degree * CGFloat.pi / 180
                    let rotateTransform    = CATransform3DRotate(identity, radian, 0, 1, 0)
                    let translateTransform = CATransform3DMakeTranslation(0, 0, 0)
                    cell.layer.transform = CATransform3DConcat(rotateTransform, translateTransform)
                    cell.debugLabel.text = String(format: "%.2f", degree)
                case .custom:
                    
                    me.isPagingEnabled = false
                    
                    if distance > 0 {
                        cell.setAnchorPoint(CGPoint(x: 0.5, y: 0.5))
                    } else {
                        cell.setAnchorPoint(CGPoint(x: 0.5, y: 0.5))
                    }

                    let scale = 1 - abs(ratio) * 0.1
                    
                    let degree: CGFloat = ratio * 30
                    let radian = degree * CGFloat.pi / 180
                    let rotateTransform    = CATransform3DRotate(identity, radian, 0, 1, 0)
                    let scaleTransform = CATransform3DMakeScale(scale, scale, 0)
                    //let translateTransform = CATransform3DMakeTranslation(0, ratio * 200, 0)
                    cell.layer.transform = CATransform3DConcat(rotateTransform, scaleTransform)
                    cell.debugLabel.text = String(format: "%.2f", degree)
                    
                case .scale:
                    
                    me.isPagingEnabled = false
                    
                    if distance > 0 {
                        cell.setAnchorPoint(CGPoint(x: 0.5, y: 0.5))
                    } else {
                        cell.setAnchorPoint(CGPoint(x: 0.5, y: 0.5))
                    }
                    
                    let scale = 1 - abs(ratio) * 0.1
                    cell.layer.transform = CATransform3DMakeScale(scale, scale, 0)
                    cell.debugLabel.text = String(format: "%.2f", scale)
                }
                
                
        }
    }
}

extension AnimationViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("Delegate Gesture")
    }
}

extension AnimationViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! AnimationCollectionViewCell
        return cell
    }
}

extension AnimationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //return CGSize(width: collectionView.frame.width - 50, height: collectionView.frame.height - 30)
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        //return 40
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


extension UIView {
    func setAnchorPoint(_ point: CGPoint) {
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

