//
//  ORUserInteractionDisabler.swift
//  Pods
//
//  Created by Maxim Soloviev on 11/05/16.
//  Copyright © 2016 Maxim Soloviev. All rights reserved.
//

import Foundation
import UIKit

open class ORUserInteractionDisabler {
    
    fileprivate var enablingTimer: Timer?
    
    public init() {
    }
    
    @discardableResult public init(disablingTime: TimeInterval) {
        disableInteractions(onTime: disablingTime)
    }
    
    /// use to turn off the Disabler for testing purposes
    open var isTurnedOff = false
    
    open func disableInteractions(onTime duration: TimeInterval) {
        guard !isTurnedOff else { return }
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        enablingTimer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(enableInteractions), userInfo: nil, repeats: false)
    }
    
    @objc open func enableInteractions() {
        guard !isTurnedOff else { return }
        
        enablingTimer?.invalidate()
        enablingTimer = nil
        if UIApplication.shared.isIgnoringInteractionEvents {
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
}
