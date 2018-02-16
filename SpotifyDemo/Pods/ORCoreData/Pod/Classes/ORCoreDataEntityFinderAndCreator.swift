//
//  ORCoreDataEntityFinderAndCreator.swift
//  Pods
//
//  Created by Maxim Soloviev on 08/04/16.
//  Copyright © 2016 Omega-R. All rights reserved.
//

import Foundation
import MagicalRecord

@objc open class ORCoreDataEntityFinderAndCreator : NSObject {
    
    public var context: NSManagedObjectContext?
    
    public init(_ context: NSManagedObjectContext) {
        self.context = context
    }
    
    open func findEntityOfType<T: NSManagedObject>(_ type: T.Type, byAttribute attr: String, withValue value: Any) -> T? {
        let obj = type.mr_findFirst(byAttribute: attr, withValue: value, in: context!)
        return obj
    }
    
    open func findFirstEntityOfType<T: NSManagedObject>(_ type: T.Type) -> T? {
        let obj = type.mr_findFirst(in: context!)
        return obj
    }
    
    open func createEntityOfType<T: NSManagedObject>(_ type: T.Type) -> T? {
        let obj = type.mr_createEntity(in: context!)
        return obj
    }
    
    open func findOrCreateEntityOfType<T: NSManagedObject>(_ type: T.Type, byAttribute attr: String, withValue value: Any) -> T {
        let obj = type.mr_findFirstOrCreate(byAttribute: attr, withValue: value, in: context!)
        return obj
    }
    
    open func countOfEntitiesOfType<T: NSManagedObject>(_ type: T.Type) -> UInt {
        let count = type.mr_countOfEntities(with: context!)
        return count
    }
}
