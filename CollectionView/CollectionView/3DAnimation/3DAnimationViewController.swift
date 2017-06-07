//
//  3DAnimationViewController.swift
//  CollectionView
//
//  Created by 横山 祥平 on 2017/06/07.
//  Copyright © 2017年 Shohei Yokoyama. All rights reserved.
//

import UIKit

class AnimationViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let cellIdentifier = "AnimationCollectionViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
        
        collectionView.dataSource = self
        collectionView.delegate   = self
    }
}

extension AnimationViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let collectionview = scrollView as? UICollectionView else {
            return
        }
        
        let middleX = collectionview.frame.width / 2
        collectionview.visibleCells.flatMap { $0 as? AnimationCollectionViewCell }
            .forEach { cell in
                let convertedFrame = collectionView.convert(cell.frame, to: collectionView.superview)
                let distance = convertedFrame.midX - middleX //右方向が+
                let ratio = distance / collectionview.frame.width
                
                cell.debugLabel.text = String(format: "%.2f", ratio)
                
                if distance > 0 {
                    cell.setAnchorPoint(CGPoint(x: 0, y: 0.5))
                } else {
                    cell.setAnchorPoint(CGPoint(x: 1, y: 0.5))
                }
                
                var identity = CATransform3DIdentity
                identity.m34 = -1.0 / 1000.0
                
                let degree: CGFloat = ratio * 90
                let radian = degree * CGFloat.pi / 180
                let rotateTransform    = CATransform3DRotate(identity, radian, 0, 1, 0)
                let translateTransform = CATransform3DMakeTranslation(ratio, 0, 0)
                
                cell.layer.transform = CATransform3DConcat(rotateTransform, translateTransform)
            }
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
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
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

