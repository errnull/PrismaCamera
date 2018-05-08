//
//  PCRootViewController.swift
//  PrismaCamera
//
//  Created by 詹瞻 on 2018/5/3.
//  Copyright © 2018年 developZHAN. All rights reserved.
//

import UIKit
import AVFoundation


class PCRootViewController: UIViewController, PCImageProtocol {
    
    @IBOutlet weak var captureHeaderView: UIView!
    var previewLayer: AVCaptureVideoPreviewLayer?
    var state: PMImageDisplayState = PMImageDisplayState.Preview
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captureHeaderView.backgroundColor = UIColor.black
        captureHeaderView.layer.masksToBounds = true
        
        // Add navigation
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let baseNavigationController = storyBoard.instantiateViewController(withIdentifier: "mainNavigationController") as? PCNavigationController
        baseNavigationController!.frameOrigin = CGPoint(x: 0, y: UIScreen.main.bounds.size.width)
        self.addChildViewController(baseNavigationController!)
        view.addSubview(baseNavigationController!.view)
        
        // Tap gesture to focus
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapHandle(tap:)))
        tapGesture.numberOfTapsRequired = 1
        captureHeaderView.addGestureRecognizer(tapGesture)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Preview
        guard let layer = previewLayer else { return }
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        layer.frame = captureHeaderView.bounds
        CATransaction.commit()
    }
    
    @objc func tapHandle(tap: UITapGestureRecognizer) {
        
        guard state == .Preview else { return }
        singleTapHeaderAction(tap)
    }
    
    // Display header view
    var displayHeaderView: UIView {
        return captureHeaderView
    }
    
    private var _singleTapHeaderAction: ((_ tap: UITapGestureRecognizer) -> Void) = {(tap: UITapGestureRecognizer) in }
    var singleTapHeaderAction: ((_ tap: UITapGestureRecognizer) -> Void) {
        set {
            _singleTapHeaderAction = newValue
        }
        get {
            return _singleTapHeaderAction
        }
    }
    
    // Set the AVCaptureVideoPreviewLayer
    func setAVCapturePreviewLayer(previewLayer: AVCaptureVideoPreviewLayer) {
        self.previewLayer = previewLayer
        captureHeaderView.layer.insertSublayer(self.previewLayer!, at: 0)
    }
}















