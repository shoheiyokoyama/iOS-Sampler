//
//  PageableViewController.swift
//  ZoomImage
//
//  Created by 横山祥平 on 2016/08/08.
//  Copyright © 2016年 Shohei. All rights reserved.
//

import UIKit

class PageableViewController: UIViewController {
    
    var scrollView = UIScrollView()
    let imageView1 = UIImageView(image: UIImage(named: "Image1"))
    let imageView2 = UIImageView(image: UIImage(named: "Image2"))
    let imageView3 = UIImageView(image: UIImage(named: "Image3"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        registerGesture()
    }
    
    private func setup() {
        scrollView.frame = view.frame
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 3
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: view.bounds.width * 3, height: view.bounds.height)
        scrollView.pagingEnabled = true
        scrollView.bouncesZoom = true
        view.addSubview(scrollView)
        
        let scroll1 = ZoomableScrollView.instanciate(imageView1.image!)
        scroll1.frame = view.frame
        scroll1.frame.origin.x += 0
        scrollView.addSubview(scroll1)
        
        let scroll2 = ZoomableScrollView.instanciate(imageView2.image!)
        scroll2.frame = view.frame
        scroll2.frame.origin.x += view.frame.width
        scrollView.addSubview(scroll2)
        
        let scroll3 = ZoomableScrollView.instanciate(imageView3.image!)
        scroll3.frame = view.frame
        scroll3.frame.origin.x += view.frame.width * 2
        scrollView.addSubview(scroll3)
    }
    
    private func registerGesture() {
        let doubleTapGesture = UITapGestureRecognizer(target: self
            , action:#selector(ViewController.doubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        imageView1.userInteractionEnabled = true
        imageView1.addGestureRecognizer(doubleTapGesture)
    }
    
    
}

// MARK: - Zoom Action

extension PageableViewController {
    func doubleTap(gesture: UITapGestureRecognizer) {
        
        if (scrollView.zoomScale == scrollView.minimumZoomScale) {
            let zoomRect = self.zoomRectForScale(scrollView.maximumZoomScale, center: gesture.locationInView(gesture.view))
            scrollView.zoomToRect(zoomRect, animated: true)
            
        } else if (scrollView.zoomScale <= scrollView.maximumZoomScale && scrollView.zoomScale > scrollView.minimumZoomScale) {
            scrollView.setZoomScale(1, animated: true)
        }
    }
    
    private func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect()
        zoomRect.size.height = scrollView.frame.size.height / scale
        zoomRect.size.width = scrollView.frame.size.width / scale
        
        zoomRect.origin.x = center.x - zoomRect.size.width / 2.0
        zoomRect.origin.y = center.y - zoomRect.size.height / 2.0
        
        return zoomRect
    }
}

// MARK: - UIScrollViewDelegate

extension PageableViewController: UIScrollViewDelegate {
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView1
    }
}

