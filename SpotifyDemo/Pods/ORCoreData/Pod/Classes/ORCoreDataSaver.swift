//
//  ORCoreDataSaver.swift
//  Pods
//
//  Created by Maxim Soloviev on 08/04/16.
//  Copyright © 2016 Omega-R. All rights reserved.
//

import Foundation
import MagicalRecord

public typealias ORCoreDataSaverSavingBlock = (_ localContext : NSManagedObjectContext, _ cancelSaving: inout Bool) -> Void
public typealias ORCoreDataSaverCompletionBlock = () -> Void
public typealias ORCoreDataSaverCompletionWithObjectIdsBlock = (_ objects: [String]) -> Void

@objc open class ORCoreDataSaver: NSObject {
    
    public static let sharedInstance = ORCoreDataSaver()
    
    let savingQueue = OperationQueue()
    
    private override init() {
        super.init()
        savingQueue.name = "ORCoreDataSaver_queue"
        savingQueue.maxConcurrentOperationCount = 1
        savingQueue.qualityOfService = .utility
    }
    
    open func saveData(_ savingBlock: @escaping ORCoreDataSaverSavingBlock,
                       success: @escaping ORCoreDataSaverCompletionBlock) -> Void {
        savingQueue.addOperation( {
            var cancelSaving = false
            
            MagicalRecord.save(blockAndWait: { (localContext) in
                savingBlock(localContext, &cancelSaving)
                
                if cancelSaving {
                    localContext.rollback()
                }
            })
            
            if !cancelSaving {
                DispatchQueue.main.async() {
                    success()
                }
            }
        })
    }
    
    open func saveData(_ savingBlock: @escaping ORCoreDataSaverSavingBlock, objectUidKey: String,
                       successWithObjectIds: @escaping ORCoreDataSaverCompletionWithObjectIdsBlock) -> Void {
        savingQueue.addOperation( {
            var cancelSaving = false
            
            var objectIds = [String]()
            
            MagicalRecord.save(blockAndWait: { (localContext : NSManagedObjectContext!) in
                savingBlock(localContext, &cancelSaving)
                
                if cancelSaving {
                    localContext.rollback()
                } else {
                    for obj in localContext.insertedObjects {
                        if let uid = obj.value(forKey: objectUidKey), uid is String {
                            objectIds.append(uid as! String)
                        }
                    }
                    for obj in localContext.updatedObjects {
                        if let uid = obj.value(forKey: objectUidKey), uid is String {
                            objectIds.append(uid as! String)
                        }
                    }
                }
            })
            
            if !cancelSaving {
                DispatchQueue.main.async() {
                    successWithObjectIds(objectIds)
                }
            }
        })
    }
}
