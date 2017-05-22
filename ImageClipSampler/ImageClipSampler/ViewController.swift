//
//  ViewController.swift
//  ImageClipSampler
//
//  Created by 横山 祥平 on 2017/05/21.
//  Copyright © 2017年 shoheiyokoyama. All rights reserved.
//

import UIKit

//500 * 333

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scale: CGFloat = 4
        let ref = imageView.image?.cgImage?.cropping(to: CGRect(x: 0, y: 0, width: 500 / scale, height: 333 / scale))
        let cloppedImage = UIImage(cgImage: ref!, scale: (imageView.image?.scale)!, orientation: (imageView.image?.imageOrientation)!)
        imageView.image = cloppedImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

