//
//  ORCoreDataRemover.swift
//  Pods
//
//  Created by Maxim Soloviev on 01/12/2016.
//  Copyright © 2016 Maxim Soloviev. All rights reserved.
//

import Foundation
import MagicalRecord

@objc open class ORCoreDataRemover: NSObject {

    open static func truncateAllOfTypes(_ managedObjectTypes: [NSManagedObject.Type], inContext context: NSManagedObjectContext) {
        for moType in managedObjectTypes {
            moType.mr_truncateAll(in: context)
        }
    }
}
