
//  ZoomableScrollView.swift
//  ZoomImage
//
//  Created by 横山祥平 on 2016/08/08.
//  Copyright © 2016年 Shohei. All rights reserved.
//

import UIKit

class ZoomableScrollView: UIScrollView {
    
    var image: UIImage?
    var imageView: UIImageView?
    
    var imageSize: CGSize?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
//
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func instanciate(image: UIImage) -> ZoomableScrollView {
        let scrollView = ZoomableScrollView()
        scrollView.image = image
        scrollView.delegate = scrollView
        scrollView.bouncesZoom = true
        return scrollView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let boundsSize = bounds.size
        var frameToCenter = imageView!.frame
        
        // center horizontally
        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
        } else {
            frameToCenter.origin.x = 0
        }
        
        // center vertically
        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
        } else {
            frameToCenter.origin.y = 0
        }
        
        imageView!.frame = frameToCenter
        
    }
    
    override var frame: CGRect {
        willSet {
            guard let image = image else { return }
            displayImage(image)
        }
    }
    
    override var bounds: CGRect {
        willSet {
            
        }
    }
}

extension ZoomableScrollView {
    func displayImage(image: UIImage) {
        if imageView != nil {
            imageView!.removeFromSuperview()
        }
        imageView = nil
        
        // reset our zoomScale to 1.0 before doing any further calculations
        zoomScale = 1
        
        // make a new UIImageView for the new image
        imageView = UIImageView(image: image)
        imageView!.userInteractionEnabled = true
        addSubview(imageView!)
        
        // add gesture recognizers to the image view
        let doubleTapGesture = UITapGestureRecognizer(target: self
            , action:#selector(ZoomableScrollView.doubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        imageView!.addGestureRecognizer(doubleTapGesture)
        
        configureImageSize(image.size)
    }
    
    func doubleTap(gesture: UITapGestureRecognizer) {
        let newScale: CGFloat
        if zoomScale != minimumZoomScale {
            newScale = 0
        } else {
            newScale = zoomScale * 2
        }
        
        let zoomRect = zoomRectForScale(newScale, withCenter: gesture.locationInView(gesture.view))
        zoomToRect(zoomRect, animated: true)
    }
    
    func zoomRectForScale(scale: CGFloat, withCenter: CGPoint) -> CGRect {
        var zoomRect: CGRect = CGRectZero
        zoomRect.size.height = frame.size.height / scale
        zoomRect.size.width = frame.size.width / scale
        
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2)
        return zoomRect
    }
    
    func configureImageSize(size: CGSize) {
        imageSize = size
        contentSize = size
        setMaxMinZoomScalesForCurrentBounds()
        zoomScale = minimumZoomScale
        
    }
    
    func setMaxMinZoomScalesForCurrentBounds() {
        let boundsSize: CGSize
        if bounds.size == CGSizeZero {
            boundsSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
        } else {
            boundsSize = bounds.size
        }
        
        let xScale = boundsSize.width / imageSize!.width
        let yScale = boundsSize.height / imageSize!.height
        
        let imagePortrait = boundsSize.height > imageSize?.width
        let phonePortrait = boundsSize.height > imageSize?.height
        
        var minScale  = imagePortrait == phonePortrait ? xScale : min(xScale, yScale)
                
        let maxScale = 2 / UIScreen.mainScreen().scale
        
        if minScale > maxScale {
            minScale = maxScale
        }
        
        maximumZoomScale = maxScale
        minimumZoomScale = minScale
    }
}

extension ZoomableScrollView: UIScrollViewDelegate {
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
