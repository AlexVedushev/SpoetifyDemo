//
//  ORMath.swift
//  Pods
//
//  Created by Maxim Soloviev on 10/09/16.
//
//

import UIKit

@objc open class ORMath: NSObject {
    
    // only static methods are available
    fileprivate override init() {
    }
    
    /**
     @param t: 0.0 - 1.0
     */
    @objc open static func lerp(_ a: CGFloat, _ b: CGFloat, _ t: CGFloat) -> CGFloat {
        let res = (a + (b - a) * t)
        return res
    }
    
    /**
     @param t: 0.0 - 1.0
     */
    @objc open static func cerp(_ a: CGFloat, _ b: CGFloat, _ t: CGFloat) -> CGFloat {
        let res = (a + (b - a) * pow(t, 3))
        return res
    }
    
    @objc open static func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let distance = hypot(a.x - b.x, a.y - b.y)
        return distance
    }
    
    open static func clamp<T: Comparable>(_ value: T, _ lower: T, _ upper: T) -> T {
        return min(max(value, lower), upper)
    }
}
