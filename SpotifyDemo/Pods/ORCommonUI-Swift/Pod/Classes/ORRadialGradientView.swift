//
//  ORRadialGradientView.swift
//  Dowoodle
//
//  Created by Maxim Soloviev on 24/06/16.
//  Copyright © 2016 Maxim Soloviev. All rights reserved.
//

import UIKit

@IBDesignable open class ORRadialGradientView: UIView {

    @IBInspectable open var innerColor: UIColor = UIColor.red.withAlphaComponent(0)
    @IBInspectable open var innerColorLocation: CGFloat = 0
    @IBInspectable open var mediumColor: UIColor = UIColor.red.withAlphaComponent(0.5)
    @IBInspectable open var mediumColorLocation: CGFloat = 0.5
    @IBInspectable open var outerColor: UIColor = UIColor.red
    @IBInspectable open var outerColorLocation: CGFloat = 1
    
    open override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        defer {
            context.restoreGState()
        }

        context.saveGState()

        let colors = [innerColor.cgColor, mediumColor.cgColor, outerColor.cgColor] as CFArray
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors, locations: [innerColorLocation, mediumColorLocation, outerColorLocation])!
        let gradCenter = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
        let gradRadius = min(bounds.size.width / 2, bounds.size.height / 2)
        context.drawRadialGradient(gradient, startCenter: gradCenter, startRadius: 0, endCenter: gradCenter, endRadius: gradRadius, options: CGGradientDrawingOptions.drawsAfterEndLocation)
    }
}
