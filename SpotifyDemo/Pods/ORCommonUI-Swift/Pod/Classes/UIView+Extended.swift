//
//  UIView+Extended.swift
//  Pods
//
//  Created by Maxim Soloviev on 26/08/16.
//  Copyright © 2016 Maxim Soloviev. All rights reserved.
//

import UIKit

extension UIView {
    
    public func or_setExclusiveTouchForViewAndSubviews(recursively: Bool = false) {
        isExclusiveTouch = true
        
        for v in subviews {
            if recursively {
                v.or_setExclusiveTouchForViewAndSubviews(recursively: true)
            } else {
                v.isExclusiveTouch = true
            }
        }
    }
}
