//
//  AppError.swift
//  Spotify Demo
//
//  Created by Alexey Vedushev on 13/02/2018.
//  Copyright © 2018 Alexey Vedushev. All rights reserved.
//

import UIKit

enum AppErrorCode : Int {
    case appErrorInternalError                      = 001
    
    case appErrorInvalidResponse                    = 100
    case appErrorEmptyJSON                          = 101
    case appErrorInvalidJSON                        = 102
}

class AppError: BaseError {
    
    static let kErrorDomain = "appError"
    static let kLocalizationPrefix = "app-error"
    static let kCategoryString = "App Error"
    
    static func errorWithCode(_ code: AppErrorCode) -> AppError {
        return AppError(domain: kErrorDomain, code: code.rawValue,
                        localizationPrefix: kLocalizationPrefix, categoryString: kCategoryString)
    }
}
