//
//  PCGroupModel.swift
//  PrismaCamera
//
//  Created by 詹瞻 on 2018/5/7.
//  Copyright © 2018年 developZHAN. All rights reserved.
//

import UIKit
import Photos

class PCGroupModel: NSObject {
    
    
    
}

extension PHAssetCollection {
    var photosCount: Int {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
        let result = PHAsset.fetchKeyAssets(in: self, options: fetchOptions)
        return (result?.count)!
    }
}
