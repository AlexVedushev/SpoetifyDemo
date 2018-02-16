//
//  UIView+Nib.swift
//  Pods
//
//  Created by Maxim Soloviev on 22/03/2017.
//  Copyright © 2017 Maxim Soloviev. All rights reserved.
//

import Foundation
import PureLayout

extension UIView {
    
    open static func or_loadFromNib() -> UIView {
        return or_loadFromNib(owner: nil)
    }
    
    open static func or_loadFromNib(owner: AnyObject?) -> UIView {
        let v = Bundle(for: self.classForCoder()).loadNibNamed(String(describing: self), owner: owner, options: nil)!.first
        return v as! UIView
    }
    
    open static func or_loadFromNib(containerToFill: UIView) -> UIView {
        return or_loadFromNib(containerToFill: containerToFill, owner: nil)
    }
    
    open static func or_loadFromNib(containerToFill: UIView, owner: AnyObject?) -> UIView {
        let v = or_loadFromNib(owner: owner)
        v.translatesAutoresizingMaskIntoConstraints = false
        containerToFill.addSubview(v)
        v.autoPinEdgesToSuperviewEdges()
        return v
    }
}
