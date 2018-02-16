//
//  ORCustomContentButton.swift
//  Pods
//
//  Created by Maxim Soloviev on 11/08/16.
//  Copyright © 2016 Maxim Soloviev. All rights reserved.
//

import UIKit

open class ORCustomContentButton: UIControl {

    var defaultAlpha: CGFloat = 1.0
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        isExclusiveTouch = true
        defaultAlpha = alpha
    }
    
    open override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.1, animations: { _ in
                self.alpha = self.isHighlighted ? 0.3 : self.defaultAlpha
            }) 
        }
    }
}
