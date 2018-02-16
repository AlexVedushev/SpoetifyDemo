//
//  BaseError.swift
//  Spotify Demo
//
//  Created by Alexey Vedushev on 13/02/2018.
//  Copyright © 2018 Alexey Vedushev. All rights reserved.
//

import Foundation

class BaseError: NSError {
    
    init(domain: String, code: Int, localizationPrefix: String, categoryString: String, alwaysUseCategoryStringAsPrefix: Bool = false) {
        let localizedFailureReasonKey = "\(localizationPrefix)-failure-reason-\(code)"
        let localizedDescriptionKey = "\(localizationPrefix)-description-\(code)"
        
        let localizedFailureReason = NSLS(localizedFailureReasonKey)
        let localizedDescription = NSLS(localizedDescriptionKey)
        
        var userInfo = [AnyHashable : Any]()
        
        if !localizedFailureReason.isEmpty && localizedFailureReason != localizedFailureReasonKey {
            userInfo[NSLocalizedFailureReasonErrorKey] = localizedFailureReason
        }
        
        var descr: String?
        if !localizedDescription.isEmpty && localizedDescription != localizedDescriptionKey {
            descr = localizedDescription
        }
        
        if descr != nil {
            if alwaysUseCategoryStringAsPrefix {
                descr = "\(categoryString): \(descr!)"
            }
        } else {
            descr = "\(categoryString) \(code)"
        }
        
        userInfo[NSLocalizedDescriptionKey] = descr
        
        super.init(domain: domain, code: code, userInfo: userInfo as? [String : Any])
    }
    
    init(domain: String, code: Int, customDescription: String) {
        let dict = [NSLocalizedDescriptionKey : customDescription]
        super.init(domain: domain, code: code, userInfo: dict)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
