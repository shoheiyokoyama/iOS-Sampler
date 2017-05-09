//
//  ViewController.swift
//  ImageFilterSampler
//
//  Created by 横山 祥平 on 2017/05/09.
//  Copyright © 2017年 Shohei Yokoyama. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            originalImage = imageView.image
        }
    }
    var originalImage: UIImage?
    
    var ciContext = CIContext(options: nil)
    
    var filterNames = [
        "CIPhotoEffectChrome",
        "CIPhotoEffectFade",
        "CIPhotoEffectInstant",
        "CIPhotoEffectNoir",
        "CIPhotoEffectProcess",
        "CIPhotoEffectTonal",
        "CIPhotoEffectTransfer",
        "CISepiaTone"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "ImageCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "ImageCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let name = filterNames[indexPath.row]
        
        let coreImage = CIImage(image: originalImage!)
        let filter = CIFilter(name: name)
        filter!.setDefaults()
        filter!.setValue(coreImage, forKey: kCIInputImageKey)
        
        let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
        let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
        imageView.image = UIImage(cgImage: filteredImageRef!)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell else {
            return .init()
        }
        
        let coreImage = CIImage(image: cell.originnalImage!)
        let filter = CIFilter(name: filterNames[indexPath.row])
        filter!.setDefaults()
        
        filter!.setValue(coreImage, forKey: kCIInputImageKey)
        //filter!.setValue(0.3, forKey: kCIInputIntensityKey)
                
        let filteredImageData = filter!.outputImage
        let filteredImageRef = ciContext.createCGImage(filteredImageData!, from: (filteredImageData?.extent)!)
        cell.contentImageView.image = UIImage(cgImage: filteredImageRef!)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

}

