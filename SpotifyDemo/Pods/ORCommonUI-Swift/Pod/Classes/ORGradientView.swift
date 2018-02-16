//
//  ORGradientView.swift
//  Pods
//
//  Created by Alexander Kurbanov on 4/8/16.
//  Copyright © 2016 Alexander Kurbanov. All rights reserved.
//

import Foundation
import UIKit

open class ORGradientView: UIView {
    
    @IBInspectable open var colorTop: UIColor = UIColor.red
    @IBInspectable open var colorBottom: UIColor = UIColor.blue
    
    // MARK: - View lifecycle
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        self.setGradient(colorTop, color2: colorBottom)
    }
    
    // MARK: - Helpers
    
    open func setGradient(_ color1: UIColor, color2: UIColor) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        defer {
            context.restoreGState()
        }
        
        let colors = [color1.cgColor, color2.cgColor] as CFArray
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors, locations: [0, 1])!
        
        // Draw Path
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        context.saveGState()
        path.addClip()
        context.drawLinearGradient(gradient, start: CGPoint(x: frame.width / 2, y: 0), end: CGPoint(x: frame.width / 2, y: frame.height), options: CGGradientDrawingOptions())
    }
}
