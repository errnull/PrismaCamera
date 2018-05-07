//
//  PCImageManager.swift
//  PrismaCamera
//
//  Created by 詹瞻 on 2018/5/6.
//  Copyright © 2018年 developZHAN. All rights reserved.
//

import UIKit
import Photos

class PCImageManager: NSObject {
    
    // MARK: Authorizations
    // Capture authorization
    class func captureAuthorization(shouldCapture: ((Bool) -> Void)!) {
        let captureStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch captureStatus {
        case .notDetermined:
            //FIXME: 这里可能有问题
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) -> Void in
                runOnMainQueue(callBack: {
                    shouldCapture(granted)
                })
            })
        case .authorized:
            shouldCapture(true)
        default:
            shouldCapture(false)
        }
    }
    
    // Run in main queue
    class func runOnMainQueue(callBack: (() -> Void)?) {
        if Thread.current.isMainThread {
            if let call = callBack {
                call()
            }
        } else {
            DispatchQueue.main.async {
                if let call = callBack {
                    call()
                }
            }
        }
    }
    
    // Photolibrary authorization
    class func photoAuthorization(canGoAssets: ((Bool) -> Void)!) {
        
        let PhotoStatus: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch PhotoStatus {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) in
                DispatchQueue.main.async {
                    switch status {
                    case .authorized:
                        canGoAssets(true)
                    default:
                        canGoAssets(false)
                    }
                }
            })
            
        case .authorized:
            canGoAssets(true)
        default:
            canGoAssets(false)
        }
    }
    
    // MARK: Photo library
    // Get photo albums
    class func photoLibrarys() -> [PHAssetCollection] {
        var photoGroups: [PHAssetCollection] = [PHAssetCollection]()
        
        // Camera
        let cameraRoll: PHAssetCollection = (PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil).lastObject)!
        if cameraRoll.photosCount > 0 {
            photoGroups.append(cameraRoll)
        }
        
        // Favorites
        let favorites: PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: nil)
        favorites.enumerateObjects(options: .reverse) { (object, index: Int, stop: UnsafeMutablePointer<ObjCBool>) in
            let collection = object as PHAssetCollection
            guard collection.photosCount > 0 else { return }
            photoGroups.append(collection)
        }
        
        // ScreenShots
        if #available(iOS 9.0, *) {
            let screenShots: PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumScreenshots, options: nil)
            screenShots.enumerateObjects(options: .reverse, using: { (object, index: Int, stop: UnsafeMutablePointer<ObjCBool>) in
                let collection = object as PHAssetCollection
                guard collection.photosCount > 0 else { return }
                photoGroups.append(collection)
            })
        }
        
        // User Photos
        let assetCollections: PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
        assetCollections.enumerateObjects(options: .reverse) { (object, index: Int, stop: UnsafeMutablePointer<ObjCBool>) in
            let collection = object as PHAssetCollection
            guard collection.photosCount > 0 else { return }
            photoGroups.append(collection)
        }
        
        return photoGroups
    }
    
    // Get photo from album
    class func photoAssetsForAlbum(collection: PHAssetCollection) -> [PHAsset] {
        var photoAssets: [PHAsset] = [PHAsset]()
        
        let assets: PHFetchResult = PHAsset.fetchKeyAssets(in: collection, options: nil)!
        assets.enumerateObjects(options: .reverse) { (object, index: Int, stop: UnsafeMutablePointer<ObjCBool>) in
            photoAssets.append(object as PHAsset)
        }
        
        return photoAssets
    }
    
    // Get image from a PHAsset
    class func imageFromAsset(asset: PHAsset, inOriginal original: Bool, toSize: CGSize?, resultHandler: @escaping (UIImage?) -> Void) {
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.resizeMode = .fast
        options.deliveryMode = .fastFormat
        
        var size = CGSize(width: 100, height: 100)
        if original {
            size = CGSize(width: CGFloat(asset.pixelWidth), height: CGFloat(asset.pixelHeight))
        } else if toSize != nil {
            size = toSize!
        }
        PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: PHImageContentMode.aspectFill, options: options) { (image: UIImage?, info: [AnyHashable : Any]?) in
            resultHandler(image)
        }
    }
}

// MARK: UIImage Extension
extension UIImage {
    // Get a image with color
    func imageWithColor(color: UIColor) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
//        let context = UIGraphicsGetCurrentContext()
        
        
        return self
    }
    
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
        
    }
}
