//
//  ORButtonWithUnderline.swift
//  Pods
//
//  Created by Maxim Soloviev on 11/04/16.
//  Copyright © 2016 Maxim Soloviev. All rights reserved.
//

import UIKit

open class ORButtonWithUnderline : UIButton {
    
    @IBInspectable open var underlineThickness: CGFloat = 1
    @IBInspectable open var underlineOffset: CGFloat = 1

    @IBInspectable open var underlineHidden: Bool = false {
        didSet {
            if underlineView != nil {
                underlineView.isHidden = underlineHidden
            }
        }
    }
    
    open weak var underlineView: UIView!
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        clipsToBounds = false
        let uv = UIView(frame: CGRect(x: 0, y: bounds.height + underlineOffset, width: bounds.width, height: underlineThickness))
        uv.backgroundColor = titleColor(for: UIControlState())
        underlineView = uv
        addSubview(underlineView)
        underlineView.isHidden = underlineHidden
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if underlineView != nil {
            underlineView.frame = CGRect(x: 0, y: bounds.height + underlineOffset, width: bounds.width, height: underlineView.frame.height)
        }
    }
}
