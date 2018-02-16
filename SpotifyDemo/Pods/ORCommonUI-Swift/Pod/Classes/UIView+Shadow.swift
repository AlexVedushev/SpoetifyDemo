//
//  UIView+Shadow.swift
//  Pods
//
//

import UIKit

extension UIView {

    open func addShadowToTransparentView(color: UIColor = UIColor.black, radius: CGFloat, opacity: Float, offset: CGSize = .zero) -> CALayer {
        let viewRadius = self.layer.cornerRadius
        
        let shadowLayer = CALayer()
        shadowLayer.shadowColor = color.cgColor
        shadowLayer.shadowOpacity = opacity
        shadowLayer.shadowRadius = radius
        shadowLayer.shadowOffset = CGSize(width: offset.width, height: offset.height)
        shadowLayer.shadowPath = UIBezierPath(roundedRect: self.frame, cornerRadius: self.layer.cornerRadius).cgPath
        
        // add mask that hide added view and remain only shadow
        let mask = CAShapeLayer()
        // correction against artefacts near the borders
        let innerPath = UIBezierPath(roundedRect: self.frame, cornerRadius: self.layer.cornerRadius)
        let diffSize = radius * 5
        let diffOrigin = diffSize / 2
        
        let outerPathFrame = CGRect(x: self.frame.origin.x - diffOrigin, y: self.frame.origin.y - diffOrigin, width: self.frame.size.width + diffSize + offset.width, height:self.frame.size.height + diffSize + offset.height)
        
        let outerPath = UIBezierPath(roundedRect: outerPathFrame, cornerRadius: viewRadius + radius * 2.5)
        outerPath.append(innerPath.reversing())
        mask.path = outerPath.cgPath
        shadowLayer.mask = mask
        
        self.layer.superlayer?.insertSublayer(shadowLayer, below: self.layer)
        return shadowLayer
    }

}
