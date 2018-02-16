//
//  ORDispatch.swift
//  Pods
//
//  Created by Maxim Soloviev on 12/04/16.
//
//

import Foundation

public func or_dispatch_in_main_queue_after(_ delayInSeconds: Double, block: @escaping () -> Void) {
    if delayInSeconds == 0 {
        DispatchQueue.main.async(execute: block)
    } else {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds, execute: block)
    }
}
