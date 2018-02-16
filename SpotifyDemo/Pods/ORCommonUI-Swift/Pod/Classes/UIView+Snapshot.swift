//
//  UIView+Snapshot.swift
//  Pods
//
//  Created by Dmitriy Mamatov on 31/01/17.
//
//

import UIKit

extension UIView {
    
    open func or_takeSnapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)

        layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
