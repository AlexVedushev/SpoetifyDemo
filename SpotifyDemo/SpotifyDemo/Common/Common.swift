//
//  Common.swift
//  Spotify Demo
//
//  Created by Alexey Vedushev on 13/02/2018.
//  Copyright © 2018 Alexey Vedushev. All rights reserved.
//

import Foundation

func NSLS(_ key: String) -> String {
    return NSLocalizedString(key, comment: "")
}


func convertDurationMSToString(duration: Double) -> String {
    let hour: Int = Int(duration / (60 * 60))
    let minute: Int = Int((duration - Double(hour * 60 * 60)) / 60)
    let seconds: Int = Int(duration - Double(hour * 60 * 60 + minute * 60))
    var result = String()
    result = hour > 0 ? result + "\(hour):" : result
    result += "\(minute):"
    var secondsStr = "\(seconds)"
    secondsStr = secondsStr.count == 1 ? "0" + secondsStr : secondsStr
    result += secondsStr
    return result
}
