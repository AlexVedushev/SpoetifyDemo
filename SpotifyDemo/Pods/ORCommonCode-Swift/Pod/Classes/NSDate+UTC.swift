//
//  NSDate+UTC.swift
//  Pods
//
//  Created by Maxim Soloviev on 02/02/16.
//
//

import Foundation

extension Date {
    
    public func or_toLocalTime() -> Date {
        let tz = TimeZone.current
        let seconds = tz.secondsFromGMT(for: self)
        return Date(timeInterval: TimeInterval(seconds), since: self)
    }
    
    public func or_toUTC() -> Date {
        let tz = TimeZone.current
        let seconds = -tz.secondsFromGMT(for: self)
        return Date(timeInterval: TimeInterval(seconds), since: self)
    }
}
