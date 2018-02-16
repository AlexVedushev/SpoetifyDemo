//
//  AppNotification.swift
//  Spotify Demo
//
//  Created by Alexey Vedushev on 13/02/2018.
//  Copyright © 2018 Alexey Vedushev. All rights reserved.
//

import Foundation

enum AppNotification: String {
    case AppNotificationServerErrorInvalidToken
    
    var name: NSNotification.Name {
        return NSNotification.Name(self.rawValue)
    }
}
