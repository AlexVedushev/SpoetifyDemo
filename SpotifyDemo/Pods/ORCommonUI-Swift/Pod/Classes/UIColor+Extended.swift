//
//  UIColor+Extended.swift
//  Pods
//
//  Created by Maxim Soloviev on 10/05/17.
//  Copyright © 2017 Maxim Soloviev. All rights reserved.
//

import UIKit

extension UIColor {
    
    public convenience init(hex: Int) {
        self.init(hex: hex, a: 1.0)
    }
    
    public convenience init(hex: Int, a: CGFloat) {
        self.init((hex >> 16) & 0xff, (hex >> 8) & 0xff, hex & 0xff, a)
    }
    
    public convenience init(_ r: Int, _ g: Int, _ b: Int) {
        self.init(r, g, b, 1.0)
    }
    
    public convenience init(_ r: Int, _ g: Int, _ b: Int, _ a: CGFloat) {
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: a)
    }
    
    public convenience init?(hexString: String) {
        guard let hex = hexString.or_hex else {
            return nil
        }
        self.init(hex: hex)
    }
}
