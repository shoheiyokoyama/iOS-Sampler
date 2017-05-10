//
//  ViewController.swift
//  LocalPhotoViewer
//
//  Created by 横山 祥平 on 2017/05/10.
//  Copyright © 2017年 Shohei Yokoyama. All rights reserved.
//

import UIKit
import Photos

//https://developer.apple.com/reference/photos/phasset#//apple_ref/doc/uid/TP40014383-CH1-SW2
class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var photoAssets: [PHAsset] = []
    var images: [UIImage] = []
    
    let assetsManager = PHImageManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "ImageCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "ImageCollectionViewCell")
        collectionView.delegate   = self
        collectionView.dataSource = self
        
        getLoaclPhoto()
    }
    
    func getLoaclPhoto() {
        let assets: PHFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
        
        let size = CGSize(width: view.bounds.size.width / 3, height: view.bounds.size.height / 3)
        
        assets.enumerateObjects({ asset, index, stop in
            self.photoAssets.append(asset as PHAsset)
            
            self.assetsManager.requestImage(for: asset, targetSize: size, contentMode: PHImageContentMode.aspectFill, options: nil) { image, info in
                self.images.append(image!)
            }
        })
        
        PHPhotoLibrary.requestAuthorization { state in
            switch state {
            case .notDetermined:
                ()
            case .restricted:
                ()
            case .denied:
                ()
            case .authorized:
                self.collectionView.reloadData()
            }
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell else {
            return .init()
        }
        
        cell.imageView.image = images[indexPath.row]
        cell.backgroundColor = .red
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        return CGSize(width: size.width / 3, height: size.height / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
}
