//
//  PCImageManager.swift
//  PrismaCamera
//
//  Created by 詹瞻 on 2018/5/6.
//  Copyright © 2018年 developZHAN. All rights reserved.
//

import UIKit

class PCImageManager: NSObject {
    
    
}

// MARK: UIImage Extension
extension UIImage {
    // Get a image with color
    func imageWithColor(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()
        
    }
}
