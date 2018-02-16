//
//  ORDashedView.swift
//  Pods
//
//  Created by Alexey Vedushev on 14.11.16.
//  Copyright © 2016 Omega-R. All rights reserved.
//

import UIKit

@IBDesignable
open class ORDashedView: UIView {

    enum OrientaionDashedLine{
        case horizontal
        case vertical
    }
    
    var orientation: OrientaionDashedLine = .horizontal 
    
    @IBInspectable var dashSize: Float = 2 {
        didSet {
            self.draw(self.frame)
        }
    }
    
    @IBInspectable var dashColor: UIColor = UIColor.white {
        didSet {
            self.draw(self.frame)
        }
    }
    
    func addDashedLine(orientation: OrientaionDashedLine) {
        let lineName = orientation == .horizontal ? "DashedHorizontalLine" : "DashedVerticalLine"
        _ = layer.sublayers?.filter({ $0.name == lineName }).map({ $0.removeFromSuperlayer() })
        self.backgroundColor = UIColor.clear
        let cgColor = dashColor.cgColor
        
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.name = lineName
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width / 2, y: frameSize.height / 2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = cgColor
        shapeLayer.lineWidth = orientation == .horizontal ? frame.height : frame.width
        shapeLayer.lineJoin = kCALineJoinRound
        let size = NSNumber(value: dashSize)
        shapeLayer.lineDashPattern = [size, size]
        
        let path: CGMutablePath = CGMutablePath()
        
        if orientation == .horizontal {
            path.move(to: CGPoint(x: 0, y: frame.height / 2))
            path.addLine(to: CGPoint(x: self.frame.width, y: frame.height / 2))
        } else {
            path.move(to: CGPoint(x: frame.width / 2, y: 0))
            path.addLine(to: CGPoint(x: frame.width / 2, y: frame.height))
        }
        
        shapeLayer.path = path
        
        self.layer.addSublayer(shapeLayer)
    }
}

open class ORHorizontalDashedView: ORDashedView {
    override open func layoutSublayers(of layer: CALayer) {
        addDashedLine(orientation: .horizontal)
    }
}

open class ORVerticalDashedView: ORDashedView {
    override open func layoutSublayers(of layer: CALayer) {
        addDashedLine(orientation: .vertical)
    }
}
