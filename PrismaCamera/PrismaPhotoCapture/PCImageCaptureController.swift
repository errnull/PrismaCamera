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
    
    @IBOutlet weak var captureButton: PCCaptureButton!
    var session: AVCaptureSession! = AVCaptureSession()
    var deviceInput: AVCaptureDeviceInput?
    var stillImageOuput: AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var photoGroups = [PHAssetCollection]()
    var photoAssets = [PHAsset]()
    var isUsingFrontFacingCamera: Bool = false
    
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
        
        // Tap header to change focus
        photoDisplayBoard?.singleTapHeaderAction = {(tap: UITapGestureRecognizer) in
            self.tapToChangeFocus(tap: tap)
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
    
    // Tap header to focus
    func tapToChangeFocus(tap: UITapGestureRecognizer) {
        guard !isUsingFrontFacingCamera else { return }
        
        // Location
        let locationPoint = tap.location(in: photoDisplayBoard?.displayHeaderView)
        // Show square
        showSquareBox(point: locationPoint)
        
        // Change focus
        let pointInCamera = previewLayer!.captureDevicePointConverted(fromLayerPoint: locationPoint)
        let device = deviceInput?.device
        
        try! device!.lockForConfiguration()
        
        if device!.isFocusPointOfInterestSupported {
            device!.focusPointOfInterest = pointInCamera
        }
        if device!.isFocusModeSupported(.continuousAutoFocus) {
            device!.focusMode = .continuousAutoFocus
        }
        if device!.isExposurePointOfInterestSupported {
            device?.exposureMode = .continuousAutoExposure
            device?.exposurePointOfInterest = pointInCamera
        }
        device?.isSubjectAreaChangeMonitoringEnabled = true
        device!.focusPointOfInterest = pointInCamera
        
        device!.unlockForConfiguration()
    }
    
    // Show focus square box
    private func showSquareBox(point: CGPoint) {
        // Remove box
        guard let header = photoDisplayBoard?.displayHeaderView else { return }
        for layer in header.layer.sublayers! {
            if layer.name == "box" {
                layer.removeFromSuperlayer()
            }
        }
        // Create a box layer
        let width = CGFloat(60)
        let box = CAShapeLayer()
        box.frame = CGRect(x: point.x - width * 0.5, y: point.y - width * 0.5, width: width, height: width)
        box.borderWidth = 1
        box.borderColor = UIColor.white.cgColor
        box.name = "box"
        header.layer.addSublayer(box)
        
        // Box animation
        let alphaAnimation = CABasicAnimation(keyPath: "opacity")
        alphaAnimation.fromValue = 1
        alphaAnimation.toValue = 0
        alphaAnimation.duration = 0.01
        alphaAnimation.beginTime = CACurrentMediaTime()
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 1.2
        scaleAnimation.toValue = 1
        scaleAnimation.duration = 0.35
        scaleAnimation.beginTime = CACurrentMediaTime()
        
        box.add(alphaAnimation, forKey: nil)
        box.add(scaleAnimation, forKey: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (0.35 + 0.2)) {
            box.removeFromSuperlayer()
        }
    }
    
    // MARK: capture button action
    @IBAction func capturePhoto(_ sender: Any) {
        // Disable the capture action
        captureButton.isEnabled = false
        
        let stillImageConnection = stillImageOuput?.connection(with: AVMediaType.video)
//        let currentDeviceOrientation = UIDevice.current.orientation
//        let avCaptureOrientation = PCD
        let avCaptureOrientation = AVCaptureVideoOrientation(rawValue: UIDevice.current.orientation.rawValue)!
        if stillImageConnection!.isVideoOrientationSupported {
            stillImageConnection!.videoOrientation = avCaptureOrientation
        }
        stillImageConnection!.videoScaleAndCropFactor = 1
        
        stillImageOuput?.captureStillImageAsynchronously(from: stillImageConnection!, completionHandler: { (imageDataSampleBuffer: CMSampleBuffer?, error: Error?) in
            let jpegData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer!)
            
            
            if let image = UIImage(data: jpegData!) {
            
                // Save photo
                let authorStatus = ALAssetsLibrary.authorizationStatus()
                if authorStatus == ALAuthorizationStatus.restricted || authorStatus == ALAuthorizationStatus.denied {
                    return
                }
                
                let library = ALAssetsLibrary()
                if self.isUsingFrontFacingCamera {
        
                    library.writeImage(toSavedPhotosAlbum: image.cgImage, orientation: ALAssetOrientation.upMirrored, completionBlock: { (url: URL?, error: Error?) in
                        NSLog("xxx")
                    })
                } else {
                    
                    let attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, imageDataSampleBuffer!, kCMAttachmentMode_ShouldPropagate)
//                    library.writeImage(toSavedPhotosAlbum: image.cgImage, orientation: ALAssetOrientation.upMirrored, completionBlock: { (url: URL?, error: Error?) in
//                        NSLog("xxx")
//                    })
                    library.writeImage(toSavedPhotosAlbum: image.cgImage, metadata: attachments as? [AnyHashable:AnyObject], completionBlock: { (url: URL?, error: Error?) in
                        NSLog("xxx")
                    })
                }
            }
        })
        
    }
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
