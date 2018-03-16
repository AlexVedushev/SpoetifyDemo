//
//  BaseManager.swift
//  SpotifyDemo
//
//  Created by Alexey Vedushev on 14/03/2018.
//  Copyright © 2018 Alexey Vedushev. All rights reserved.
//

import Foundation
import ORCoreData
import MagicalRecord

class BaseManager {
    var defaultContext: NSManagedObjectContext {
        return NSManagedObjectContext.mr_default()
    }
}
