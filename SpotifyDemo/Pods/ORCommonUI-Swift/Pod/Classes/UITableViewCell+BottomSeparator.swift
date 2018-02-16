//
//  UITableViewCell+BottomSeparator.swift
//  Pods
//
//  Created by Maxim Soloviev on 30.06.16.
//  Copyright © 2016 Maxim Soloviev. All rights reserved.
//

import Foundation

extension UITableViewCell {
    
    public func or_addBottomSeparatorWithColor(_ color: UIColor, insets: UIEdgeInsets = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)) -> UIView! {
        let splitView = UIView(frame: self.bounds)
        splitView.translatesAutoresizingMaskIntoConstraints = false
        splitView.backgroundColor = color
        self.contentView.addSubview(splitView)
        
        let leftConstraint = NSLayoutConstraint(item: splitView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: insets.left)
        
        let rightConstraint = NSLayoutConstraint(item: splitView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: -insets.right)
        
        let bottomConstraint = NSLayoutConstraint(item: splitView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0)
        
        let heightConstraint = NSLayoutConstraint(item: splitView, attribute: .height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 1 / UIScreen.main.scale)
        
        addConstraints([leftConstraint, rightConstraint, bottomConstraint, heightConstraint])
        
        return splitView;
    }
}
