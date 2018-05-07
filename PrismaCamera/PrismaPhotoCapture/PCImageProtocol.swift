//
//  PCImageProtocol.swift
//  PrismaCamera
//
//  Created by 詹瞻 on 2018/5/7.
//  Copyright © 2018年 developZHAN. All rights reserved.
//

import UIKit
import AVFoundation

@objc protocol PCImageProtocol {
    
    // Set the AVCaptureVideoPreviewLayer
    func setAVCapturePreviewLayer(previewLayer: AVCaptureVideoPreviewLayer)
    
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
