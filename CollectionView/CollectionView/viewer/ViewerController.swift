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
    
    fileprivate let identifier = "ViewerCollectionViewCell"
    
    @IBOutlet weak var bottomBarView: UIView!
    @IBOutlet weak var topBarView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    fileprivate var displayedIndex = 0
    
    fileprivate var currentIndex: IndexPath = IndexPath(row: 0, section: 0)
    
    fileprivate enum State {
        case viewer, grid
    }
    
    fileprivate var item: [Int] = [Int](repeating: 0, count: 15/*　 適当　*/)
    fileprivate var moreItem: [Int] = [Int](repeating: 0, count: 10/*　 適当　*/)
    
    fileprivate var state: State = .viewer {
        didSet {
            if state == .viewer {
                collectionView.isPagingEnabled = true
            } else {
                collectionView.isPagingEnabled = false
            }
        }
    }
    
    // MARK: - View cycle methods -

    override func viewDidLoad() {
        super.viewDidLoad()
     
        registerCell()
        configureCollectionView()
        titleLabel.text = "タイトルタイトルタイトル"        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

private extension ViewerController {
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.setCollectionViewLayout(viewerLayout(), animated: false)
    }
    
    func registerCell() {
        let nib = UINib(nibName: identifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    // MARK: - Button Gesture -
    
    @IBAction func tap(_ sender: AnyObject) {
//        navigationController?.pushViewController(vc!, animated: true)
        
        let cell = collectionView.visibleCells.first!
        currentIndex = collectionView.indexPath(for: cell)!
        
        displayedIndex = 0
        topBarView.isHidden = true
        bottomBarView.isHidden = true
        
        collectionView.performBatchUpdates({
            self.collectionView.setCollectionViewLayout(self.gridLayout(), animated: false)
            self.collectionView.reloadData()
            },completion: { _ in
                self.state = .grid
                self.toGridAnimation()
        })
        
    }
    
    // MARK: - Layout -
    
    func viewerLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: view.bounds.width, height: view.bounds.height)
        layout.sectionInset = UIEdgeInsets.zero
        return layout
    }
    
    func gridLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
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
        let cell = collectionView.cellForItem(at: currentIndex) as? ViewerCollectionViewCell
        
        let alphaView = UIView(frame: collectionView.frame)
        alphaView.backgroundColor = UIColor.white
        collectionView.addSubview(alphaView)
        
        let imageView = UIImageView(image: UIImage(named: "article_image２"))
        imageView.frame = CGRect(x: 0, y: self.collectionView.contentOffset.y, width: self.view.frame.width, height: self.view.frame.height)
        collectionView.addSubview(imageView)
        
        UIView.animate(withDuration: 0.4,
            animations: {
                alphaView.alpha = 0.2
                imageView.frame = cell!.frame
            },
            completion: { _ in
                imageView.removeFromSuperview()
                alphaView.removeFromSuperview()
        })
        
    }
    
    fileprivate func toViewerAnimation(_ cell: ViewerCollectionViewCell) {
        let alphaView = UIView(frame: collectionView.frame)
        alphaView.backgroundColor = UIColor.white
        alphaView.alpha = 0
        collectionView.addSubview(alphaView)
        
        let imageView = UIImageView(image: UIImage(named: "article_image２"))
        imageView.frame = cell.frame
        collectionView.addSubview(imageView)
        
        UIView.animate(withDuration: 0.4,
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
                        self.state = .viewer
                        self.collectionView.scrollToItem(at: self.currentIndex, at: UICollectionViewScrollPosition(), animated: false)
                })
        })
    }
}

// MARK: - Lazy Load -

extension ViewerController {
    func nextLoad() {
        item = item + moreItem
        collectionView.reloadData()
    }
    
    func prevLoad() {
        item = moreItem + item
        collectionView.reloadData()
    }
}

// MARK: - UIScrollViewDelegate -

extension ViewerController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if state != .grid { return }
        
        let offset = scrollView.contentOffset
        let y = offset.y + scrollView.bounds.height - scrollView.contentInset.bottom
        let h = scrollView.contentSize.height
        
        if y > h - 25 {//画面下から25px
            nextLoad()
        }
        
        if offset.y - scrollView.contentInset.top < -50 {
            prevLoad()
        }
    }
}

// MARK: - UICollectionViewDelegate -

extension ViewerController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if state == .grid {
            
            
            topBarView.isHidden = false
            bottomBarView.isHidden = false
            
            let cell = collectionView.cellForItem(at: indexPath) as? ViewerCollectionViewCell
            currentIndex = collectionView.indexPath(for: cell!)!
            toViewerAnimation(cell!)
        }
    }
}

// MARK: - UICollectionViewDataSource -

extension ViewerController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return item.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! ViewerCollectionViewCell
        cell.indexLabel.text = "\(indexPath.row)"
        
        if state == .grid && indexPath.row >= displayedIndex {
            cell.articleImage.alpha = 0
            UIView.animate(withDuration: 0.9, animations: {
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
