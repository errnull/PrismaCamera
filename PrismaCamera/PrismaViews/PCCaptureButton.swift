//
//  PCCaptureButton.swift
//  PrismaCamera
//
//  Created by Loong on 2018/5/8.
//  Copyright © 2018年 developZHAN. All rights reserved.
//

import UIKit

class PCCaptureButtonContent: UIView {
    
    var lineWidth: CGFloat = 1
    var lineColor: UIColor = UIColor.black
    var fillColor: UIColor = UIColor.gray
    var enableColor: UIColor = UIColor.lightGray
    
    var centerOffset: CGFloat = (1.0 / UIScreen.main.scale) / 2
    let screenScale: CGFloat = UIScreen.main.scale
    
    private var _isEnabled: Bool = true
    var isEnabled: Bool {
        set {
            _isEnabled = newValue
            setNeedsDisplay()
        }
        get {
            return _isEnabled
        }
    }
    
    override func draw(_ rect: CGRect) {
        // Draw circle
        let edgeInset: CGFloat = 2
        let centerX = floatPixelRound(value: bounds.size.width * 0.5)
        let centerY = floatPixelRound(value: bounds.size.height * 0.5)
        let radius = floatPixelRound(value: bounds.size.width * 0.5 - 2 * edgeInset)
        if (lineWidth * screenScale) / 2 == 0 {
            centerOffset = 0
        }
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setStrokeColor(lineColor.cgColor)
        context.setLineWidth(lineWidth)
        context.setFillColor(fillColor.cgColor)
        context.addArc(center: CGPoint(x: centerX + centerOffset, y: centerY + centerOffset), radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        context.drawPath(using: CGPathDrawingMode.fillStroke)
        
        if isEnabled == false {
            context.saveGState()
            context.setFillColor(enableColor.cgColor)
            context.addArc(center: CGPoint(x: centerX + centerOffset, y: centerY + centerOffset), radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
            context.drawPath(using: CGPathDrawingMode.fill)
        }
    }
    
    func floatPixelRound(value: CGFloat) -> CGFloat {
        let scale = screenScale
        return round(value * scale) / scale
    }
}

class PCCaptureButton: UIButton {
    
    var lineWidth: CGFloat = 1
    var lineColor: UIColor = UIColor(red: 78, green: 78, blue: 78, alpha: 1)
    var fillColor: UIColor = UIColor(red: 245, green: 245, blue: 245, alpha: 1)
    var enabledColor: UIColor = UIColor(white: 0.98, alpha: 0.75)
    let content = PCCaptureButtonContent()
    var shouldLayout = true
    var targets: [AnyObject] = [AnyObject]()
    
    override var isEnabled: Bool {
        didSet {
            content.isEnabled = isEnabled
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        configViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
        configViews()
    }
    
    override func layoutSubviews() {
        guard shouldLayout else { return }
        content.frame = bounds
    }
    
    func configViews() {
        content.backgroundColor = UIColor.clear
        content.frame = bounds
        content.lineColor = lineColor
        content.lineWidth = lineWidth
        content.fillColor = fillColor
        content.enableColor = enabledColor
        content.isUserInteractionEnabled = false
        addSubview(content)
        
        backgroundColor = UIColor.black
    }
}
