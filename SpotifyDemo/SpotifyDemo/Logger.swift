//
//  Logger.swift
//  Spotify Demo
//
//  Created by Alexey Vedushev on 13/02/2018.
//  Copyright © 2018 Alexey Vedushev. All rights reserved.
//

import Foundation

class Logger {
    
    fileprivate init() {
    }
    
    static func error(_ e: NSError, track: Bool = true) {
        error("\(e)", track: track)
    }
    
    static func error(_ text: String, track: Bool = true) {
        print("\nError: \(text)")
    }
}
