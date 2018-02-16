//
//  ORDependentOnScreenScaleSeparator.swift
//  Pods
//
//  Created by Maxim Soloviev on 30/03/16.
//  Copyright © 2016 Maxim Soloviev. All rights reserved.
//

import UIKit

open class ORDependentOnScreenScaleSeparator: UIImageView {

    @IBInspectable open var affectWidth: Bool = false
    @IBInspectable open var affectHeight: Bool = false
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        for constraint in constraints {
            // Set height of exactly one pixel if this view is using constraints
            if affectWidth && constraint.firstAttribute == NSLayoutAttribute.width {
                constraint.constant /= UIScreen.main.scale
            }
            
            if affectHeight && constraint.firstAttribute == NSLayoutAttribute.height {
                constraint.constant /= UIScreen.main.scale
            }
        }
    }
}
