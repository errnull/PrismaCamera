//
//  PCNavigationController.swift
//  PrismaCamera
//
//  Created by 詹瞻 on 2018/5/3.
//  Copyright © 2018年 developZHAN. All rights reserved.
//

import UIKit

class PCNavigationController: UINavigationController {
    var frameOrigin: CGPoint = CGPoint.zero
    
    override func viewDidLoad() {
        
    }
    
    // MARK: Change the frame of the default view, under the capture view
    override func viewDidLayoutSubviews() {
        var frame = view.frame
        frame.origin.y = frameOrigin.y
        frame.size.height = UIScreen.main.bounds.size.height - frame.origin.y
        view.frame = frame
    }
}
