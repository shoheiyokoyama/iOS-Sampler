//
//  ViewerController.swift
//  CollectionView
//
//  Created by 横山 祥平 on 2016/07/25.
//  Copyright © 2016年 Shohei Yokoyama. All rights reserved.
//

import UIKit

final class ViewerController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let identifier = "ViewerCollectionViewCell"
    
    @IBOutlet weak var bottomBarView: UIView!
    @IBOutlet weak var topBarView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    private var displayedIndex = 0
    
    private var currentIndex: NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    
    private enum State {
        case viewer, grid
    }
    
    private var state: State = .viewer {
        didSet {
            if state == .viewer {
                collectionView.pagingEnabled = true
            } else {
                collectionView.pagingEnabled = false
                collectionView.setCollectionViewLayout(gridLayout(), animated: false)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
     
        registerCell()
        configureCollectionView()
        titleLabel.text = "タイトルタイトルタイトル"        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

private extension ViewerController {
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.pagingEnabled = true
        collectionView.setCollectionViewLayout(viewerLayout(), animated: false)
    }
    
    private func registerCell() {
        let nib = UINib(nibName: identifier, bundle: nil)
        collectionView.registerNib(nib, forCellWithReuseIdentifier: identifier)
    }
    
    @IBAction private func tap(sender: AnyObject) {
//        navigationController?.pushViewController(vc!, animated: true)
        
        let cell = collectionView.visibleCells().first!
        currentIndex = collectionView.indexPathForCell(cell)!
        
        state = state == .viewer ? .grid : .viewer
        displayedIndex = 0
        topBarView.hidden = true
        bottomBarView.hidden = true
        
        collectionView.performBatchUpdates({
            self.collectionView.setCollectionViewLayout(self.gridLayout(), animated: false)
            self.collectionView.reloadData()
            },completion: { _ in
                self.toGridAnimation()
        })
        
    }
    
    private func viewerLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: view.bounds.width, height: view.bounds.height)
        layout.sectionInset = UIEdgeInsetsZero
        return layout
    }
    
    private func gridLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        
        let margin: CGFloat = 5
        let height: CGFloat = 150
        let rowCount: CGFloat = 3
        
        layout.itemSize = CGSize(width: view.frame.width / rowCount - (margin * (rowCount - 1) / rowCount), height: height)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: margin, right: 0)
        
        return layout
    }
}

// MARK: - Animation -

extension ViewerController {
    func toGridAnimation() {
        let cell = collectionView.cellForItemAtIndexPath(currentIndex) as? ViewerCollectionViewCell
        print(cell?.frame)
        
        let alphaView = UIView(frame: collectionView.frame)
        alphaView.backgroundColor = UIColor.whiteColor()
        collectionView.addSubview(alphaView)
        
        let imageView = UIImageView(image: UIImage(named: "article_image２"))
        imageView.frame = collectionView.frame
        collectionView.addSubview(imageView)
        self.collectionView.contentOffset = CGPoint.zero
        
        UIView.animateWithDuration(0.4,
            animations: {
                alphaView.alpha = 0.2
                imageView.frame = cell!.frame
            },
            completion: { _ in
                imageView.removeFromSuperview()
                alphaView.removeFromSuperview()
        })
        
    }
    
    private func toViewerAnimation(cell: ViewerCollectionViewCell) {
        let alphaView = UIView(frame: collectionView.frame)
        alphaView.backgroundColor = UIColor.whiteColor()
        alphaView.alpha = 0
        collectionView.addSubview(alphaView)
        
        let imageView = UIImageView(image: UIImage(named: "article_image２"))
        imageView.frame = cell.frame
        collectionView.addSubview(imageView)
        
        UIView.animateWithDuration(0.4,
            animations: {
                alphaView.alpha = 1
                imageView.frame = CGRect(x: 0, y: self.collectionView.contentOffset.y, width: self.view.frame.width, height: self.view.frame.height)
            },
            completion: { _ in
                self.collectionView.setCollectionViewLayout(self.viewerLayout(), animated: false)
                
                imageView.removeFromSuperview()
                alphaView.removeFromSuperview()
                
                //tapしたcellにスクロール
                self.collectionView.performBatchUpdates({
                    self.collectionView.reloadData()
                    },completion: { _ in
                        self.collectionView.scrollToItemAtIndexPath(self.currentIndex, atScrollPosition: .None, animated: false)
                })
        })
    }
}

extension ViewerController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if state == .grid {
            state = state == .viewer ? .grid : .viewer
            
            topBarView.hidden = false
            bottomBarView.hidden = false
            
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as? ViewerCollectionViewCell
            currentIndex = collectionView.indexPathForCell(cell!)!
            toViewerAnimation(cell!)
        }
    }
}

extension ViewerController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! ViewerCollectionViewCell
        
        if state == .grid && indexPath.row >= displayedIndex {
            cell.articleImage.alpha = 0
            UIView.animateWithDuration(0.9, animations: {
                cell.articleImage.alpha = 1
            })
            displayedIndex = max(indexPath.row, displayedIndex)
        }
        
        return cell
    }
}















//extension ViewerController: UICollectionViewDelegateFlowLayout {
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        if state == .viewer {
//            return CGSize(width: view.bounds.width, height: view.bounds.height)
//        } else {
//            let margin: CGFloat = 5
//            let height: CGFloat = 150
//            
//            let rowCount: CGFloat = 3
//            //121.666666666667
//            return CGSize(width: view.frame.width / rowCount - (margin * (rowCount - 1) / rowCount), height: height)
//        }
//    }
//    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
//        if state == .viewer {
//            return UIEdgeInsetsZero
//        } else {
//            let margin: CGFloat = 5
//            return UIEdgeInsets(top: 0, left: 0, bottom: margin, right: 0)
//        }
//    }
//}
