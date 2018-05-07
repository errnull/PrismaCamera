//
//  PCImageCaptureController.swift
//  PrismaCamera
//
//  Created by 詹瞻 on 2018/5/6.
//  Copyright © 2018年 developZHAN. All rights reserved.
//

import UIKit
import AVFoundation
import AssetsLibrary
import Photos
import CoreImage

class PCImageCaptureController: UIViewController {
    
    var session: AVCaptureSession! = AVCaptureSession()
    var deviceInput: AVCaptureDeviceInput?
    var stillImageOuput: AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var photoGroups = [PHAssetCollection]()
    var photoAssets = [PHAsset]()
    
    override func viewDidLoad() {
        
        // Init view
        initNavigationBar()
        
        // Auth
        PCImageManager.captureAuthorization { (canCapture: Bool) in
            if canCapture {
                self.initAVCapture()
                self.session.startRunning()
            } else {
                self.session.stopRunning()
            }
        }
        
        PCImageManager.photoAuthorization { (canGoAssets: Bool) in
            if canGoAssets {
                self.photoGroups = PCImageManager.photoLibrarys()
                self.photoAssets = PCImageManager.photoAssetsForAlbum(collection: self.photoGroups.first!)
                PCImageManager.imageFromAsset(asset: self.photoAssets.first!, inOriginal: false, toSize: CGSize(width: 150, height: 150), resultHandler: { (image: UIImage?) in
//                    self.sele
                })
            }
        }
        
    }
    
    func initNavigationBar() {
        // Naviagtion bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarPosition.top, barMetrics: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let navigationItem = self.navigationController?.navigationBar.topItem
        
        // Flash button
        let flashButton = UIButton(type: UIButtonType.system)
        flashButton.frame = CGRect(x: -10, y: 0, width: 44, height: 44)
        flashButton.setImage(#imageLiteral(resourceName: "flash"), for: UIControlState.normal)
        
        let flashBarItem = UIBarButtonItem(customView: flashButton)
        flashBarItem.imageInsets = UIEdgeInsetsMake(0, -10, 0, 10)
        navigationItem!.leftBarButtonItem = flashBarItem
        
        // Camera possion
        let image = #imageLiteral(resourceName: "flip")
//        let lightGrayImage = image?.imageWithColor(color: UIColor.lightGray)
        let titleButton = UIButton(type: UIButtonType.system)
        titleButton.setImage(image, for: UIControlState.normal)
//        titleButton.setImage(lightGrayImage, for: UIControlState.selected)
//        titleButton.setImage(lightGrayImage, for: UIControlState.highlighted)
        titleButton.sizeToFit()
        navigationItem!.titleView = titleButton
        
        // Camera setting
        let settingButton = UIButton(type: UIButtonType.system)
        settingButton.setImage(#imageLiteral(resourceName: "settings"), for: UIControlState.normal)
        settingButton.sizeToFit()
        let settingBarItem = UIBarButtonItem(customView: settingButton)
        settingBarItem.imageInsets = UIEdgeInsetsMake(0, -10, 0, 0)
        navigationItem!.rightBarButtonItem = settingBarItem
    }
    
    func initAVCapture() {
        
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        
        try! device.lockForConfiguration()
        if device.hasFlash {
            device.flashMode = AVCaptureDevice.FlashMode.off
        }
        if device.isFocusModeSupported(.autoFocus) {
            device.focusMode = AVCaptureDevice.FocusMode.autoFocus
        }
        if device.isWhiteBalanceModeSupported(.autoWhiteBalance) {
            device.whiteBalanceMode = .autoWhiteBalance
        }
        if device.isExposurePointOfInterestSupported {
            device.exposureMode = .continuousAutoExposure
        }
        device.unlockForConfiguration()
        
        // Input & Output
        // When init AVCaptureDeviceInput first, system will show alert to confirm the auth from user.
        // But the best way is send the access request manual. see 'requestAccessForMediaType'
        deviceInput = try! AVCaptureDeviceInput(device: device)
        stillImageOuput = AVCaptureStillImageOutput()
        
        // Output settings
        stillImageOuput?.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG, AVVideoScalingModeKey:AVVideoScalingModeResize]
        if session.canAddInput(deviceInput!) {
            session.addInput(deviceInput!)
        }
        if session.canAddOutput(stillImageOuput!) {
            session.addOutput(stillImageOuput!)
        }
        session.sessionPreset = AVCaptureSession.Preset.photo
        
        // Preview
        previewLayer = AVCaptureVideoPreviewLayer.init(session: session)
        previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        // Set rootViewController AVCapture preview layer
        photoDisplayBoard?.setAVCapturePreviewLayer(previewLayer: previewLayer!)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
