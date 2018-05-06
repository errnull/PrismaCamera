//
//  PCRootViewController.swift
//  PrismaCamera
//
//  Created by 詹瞻 on 2018/5/3.
//  Copyright © 2018年 developZHAN. All rights reserved.
//

import UIKit
import AVFoundation


class PCRootViewController: UIViewController {
    
    @IBOutlet weak var captureHeaderView: UIView!
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captureHeaderView.backgroundColor = UIColor.black
        captureHeaderView.layer.masksToBounds = true
        
        // Add navigation
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let baseNavigationController = storyBoard.instantiateViewController(withIdentifier: "mainNavigationController") as? PCNavigationController
        baseNavigationController!.frameOrigin = CGPoint.init(x: 0, y: UIScreen.main.bounds.size.width)
        self.addChildViewController(baseNavigationController!)
        view.addSubview(baseNavigationController!.view)
        
        // Tap gesture to focus
        let tapGesture = UITapGestureRecognizer.init(target: self, action: Selector(("tapHandle")))
        tapGesture.numberOfTapsRequired = 1
        captureHeaderView.addGestureRecognizer(tapGesture)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Preview
        if let layer = previewLayer {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            layer.frame = captureHeaderView.bounds
            CATransaction.commit()
        }
    }
    
    func tapHandle(tap: UITapGestureRecognizer) {
        NSLog("xxx")
    }
}
