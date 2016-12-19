//
//  ViewController.swift
//  TableView
//
//  Created by 横山祥平 on 2016/12/12.
//  Copyright © 2016年 Shohei. All rights reserved.
//

import UIKit

extension UITableView {
    func registerCell<T: UITableViewCell>(_ type: T.Type) {
        let className = String.className(type)
        let nib       = UINib(nibName: className, bundle: nil)
        register(nib, forCellReuseIdentifier: className)
    }
    
    func registerHeader<T: UITableViewHeaderFooterView>(_ type: T.Type) {
        let className = String.className(type)
        let nib       = UINib(nibName: className, bundle: nil)
        register(nib, forHeaderFooterViewReuseIdentifier: className)
    }
    
    func dequeueCell<T: UITableViewCell>(_ type: T.Type, indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: String.className(type), for: indexPath) as! T
    }
    
    func dequeueHeader<T: UITableViewHeaderFooterView>(_ type: T.Type) -> T {
        return dequeueReusableHeaderFooterView(withIdentifier: String.className(type)) as! T
    }
}

extension String {
    static func className(_ aClass: AnyClass) -> String {
        guard let className = NSStringFromClass(aClass).components(separatedBy: ".").last else { return "" }
        return className
    }
}

class ViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate   = self
        tableView.dataSource = self
        tableView.contentInset.top = 30
        tableView.registerCell(MyCell.self)
        tableView.registerHeader(MyHeaderView.self)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
}

// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        let vc = ViewController()
//        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueHeader(MyHeaderView.self)
        header.titleLabel.text = "\(section) header"
        return header
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(MyCell.self, indexPath: indexPath)
        return cell
    }
}

