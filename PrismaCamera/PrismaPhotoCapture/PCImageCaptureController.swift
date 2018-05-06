//
//  PCImageCaptureController.swift
//  PrismaCamera
//
//  Created by 詹瞻 on 2018/5/6.
//  Copyright © 2018年 developZHAN. All rights reserved.
//

import UIKit

class PCImageCaptureController: UIViewController {
    
    override func viewDidLoad() {
        
        // Init view
        initNavigationBar()
        
    }
    
    func initNavigationBar() {
        // Naviagtion bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(), for: UIBarPosition.top, barMetrics: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage.init()
        
        let navigationItem = self.navigationController?.navigationBar.topItem
        
        // Flash button
        let flashButton = UIButton.init(type: UIButtonType.system)
        flashButton.frame = CGRect.init(x: -10, y: 0, width: 44, height: 44)
        flashButton.setImage(UIImage.init(named: "flash"), for: UIControlState.normal)
        
        let flashBarItem = UIBarButtonItem.init(customView: flashButton)
        flashBarItem.imageInsets = UIEdgeInsetsMake(0, -10, 0, 10)
        navigationItem?.leftBarButtonItem = flashBarItem
        
        // Camera possion
        let image = UIImage.init(named: "flip")
//        let lightGrayImage = image.
    }
}
