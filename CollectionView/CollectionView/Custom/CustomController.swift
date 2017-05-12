//
//  CustomController.swift
//  CollectionView
//
//  Created by 横山祥平 on 2016/08/18.
//  Copyright © 2016年 Shohei Yokoyama. All rights reserved.
//

import UIKit

class CustomController: UIViewController {
    
    let cellIdentifier = "CustomCell"
    let headerIdentifier = "CustomCollectionHeaderReusableView"

    @IBOutlet weak var collectionView: UICollectionView!
    
    var isExpanded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        collectionView.collectionViewLayout = {
           let l = UICollectionViewFlowLayout()
            if #available(iOS 10.0, *) {
                //この場合、func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize は呼ばれない
                l.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
            } else {
                // Fallback on earlier versions
            }
            return l
        }()
        
        let headerNib = UINib(nibName: headerIdentifier, bundle: nil)
        collectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    }
}

extension CustomController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.reloadItems(at: [IndexPath(row: 1, section: 0)])
        isExpanded = !isExpanded
        
    }
}

extension CustomController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CustomCell
        cell.configure()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "CustomCollectionHeaderReusableView", for: indexPath) as? CustomCollectionHeaderReusableView else { return .init() }
        
        headerView.backgroundColor = UIColor.white
        return headerView
    }
}

extension CustomController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let margin: CGFloat = 5
        let height: CGFloat = 150
        
        let rowCount: CGFloat = 3
        
        //For change Height
//        if indexPath.row == 1 {
//            return CGSize(width: view.frame.size.width, height: isExpanded ? 20 : 50)
//        }
//        return CGSize(width: view.frame.size.width, height: 50)
//        
        return CGSize(width: view.frame.width / rowCount - (margin * (rowCount - 1) / rowCount), height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let margin: CGFloat = 5
        return UIEdgeInsets(top: 0, left: 0, bottom: margin, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: 300, height: 50)
        }
        return .zero
    }
}


