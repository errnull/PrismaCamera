//
//  PCImageProtocol.swift
//  PrismaCamera
//
//  Created by 詹瞻 on 2018/5/7.
//  Copyright © 2018年 developZHAN. All rights reserved.
//

import UIKit
import AVFoundation

@objc enum PMImageDisplayState: Int {
    case Preview        // Display AVCapturePreviewLayer
    case EditImage      // Edit image, such as rotate, scale
    case SingleShow     // Just display image to make art photo
}

@objc protocol PCImageProtocol {
    
    // Display header view
    var displayHeaderView: UIView { get }
    
    // Set the AVCaptureVideoPreviewLayer
    func setAVCapturePreviewLayer(previewLayer: AVCaptureVideoPreviewLayer)
    
    // Tap header to focus
    var singleTapHeaderAction: ((_ tap: UITapGestureRecognizer) -> Void) { set get }
    
}

extension UIViewController {
    var photoDisplayBoard: PCImageProtocol? {
        get {
            let viewController = UIApplication.shared.keyWindow?.rootViewController
            if let rootViewController = viewController as? PCRootViewController {
                return rootViewController
            }
            return nil
        }
    }
}
