//
//  ViewController.swift
//  LocalPhotoViewer
//
//  Created by 横山 祥平 on 2017/05/10.
//  Copyright © 2017年 Shohei Yokoyama. All rights reserved.
//

import UIKit
import Photos

//https://developer.apple.com/reference/photos/phasset#//apple_ref/doc/uid/TP40014383-CH1-SW2¥

//https://developer.apple.com/library/content/samplecode/UsingPhotosFramework/Introduction/Intro.html#//apple_ref/doc/uid/TP40014575-Intro-DontLinkElementID_2


//Good article
//http://nshipster.com/phimagemanager/
class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var photoAssets: [PHAsset] = []
    var images: [UIImage] = [] //unused
    
    let assetsManager = PHImageManager.default()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "ImageCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "ImageCollectionViewCell")
        collectionView.delegate   = self
        collectionView.dataSource = self
        
        
        getLoaclAsset()
        requestAuthorization()
    }
    
    func getLoaclAsset() {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        //options.fetchLimit = 20
        
        let assets: PHFetchResult = PHAsset.fetchAssets(with: .image, options: options)
        
        assets.enumerateObjects({ asset, index, stop in
            self.photoAssets.append(asset as PHAsset)
            print("enumerateObjects: \(index) \(Thread.isMainThread)")
        })
    }
    
    func requestAuthorization() {
        PHPhotoLibrary.requestAuthorization { state in
            switch state {
            case .notDetermined:
                ()
            case .restricted:
                ()
            case .denied:
                ()
            case .authorized:
                print("authorized") // finish enumerateObjects
                self.collectionView.reloadData()
            }
        }
    }
    
    func requestImage() {
        let size = CGSize(width: view.bounds.size.width / 3, height: view.bounds.size.height / 3)
        photoAssets.enumerated().forEach { index, asset in
            self.assetsManager.requestImage(for: asset, targetSize: size, contentMode: PHImageContentMode.aspectFill, options: nil) { image, info in
                print("requestImage: \(index) \(Thread.isMainThread)")
                self.images.append(image!)
            }
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoAssets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell else {
            return .init()
        }
        
        let size = CGSize(width: view.bounds.size.width / 3, height: view.bounds.size.height / 3)
        
        assetsManager.requestImage(for: photoAssets[indexPath.row], targetSize: size, contentMode: PHImageContentMode.aspectFill, options: nil) { image, info in
            cell.imageView.image = image
        }
        
        //cell.imageView.image = images[indexPath.row]
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
