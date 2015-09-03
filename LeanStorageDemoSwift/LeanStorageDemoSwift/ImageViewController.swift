//
//  ImageViewController.swift
//  LeanStorageDemoSwift
//
//  Created by lzw on 15/9/3.
//  Copyright (c) 2015年 微信:  lzwjava. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    var image: UIImage?
    var _imageView: UIImageView?
    var imageView: UIImageView {
        set {
            _imageView = newValue
        }
        
        get {
            if _imageView == nil {
                _imageView = UIImageView(frame: self.view.frame)
                _imageView!.backgroundColor = UIColor.whiteColor()
                _imageView!.contentMode = UIViewContentMode.Center
                _imageView!.image = self.image
            }
            return _imageView!;
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "图片"
        self.view.addSubview(self.imageView)
        // Do any additional setup after loading the view.
    }

}
