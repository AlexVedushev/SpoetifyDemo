//
//  ORRoundRectButton.swift
//  Pods
//
//  Created by Maxim Soloviev on 11/04/16.
//  Copyright © 2016 Maxim Soloviev. All rights reserved.
//

import UIKit

open class ORRoundRectView : UIView {
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        clipsToBounds = true
        layer.cornerRadius = bounds.height / 2
    }
}

open class ORRoundRectButton : UIButton {
    
    override open func layoutSubviews() {
        super.layoutSubviews()

        clipsToBounds = true
        layer.cornerRadius = bounds.height / 2
    }
}

open class ORRoundRectImageView : UIImageView {
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        clipsToBounds = true
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
    }
}
