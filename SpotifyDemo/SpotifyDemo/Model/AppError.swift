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
    
    case appErrorNeedToCreateNewCursor              = 103
    case appErrorDuplicatedItemsInFeedList          = 104
    case appErrorFeedListQueryInProgress            = 105
    
    case appErrorCoreDataFetch                      = 200
    case appErrorCoreDataCreate                     = 201
    
    case appErrorSceneNotFound                      = 404
    
    case appErrorARSceneNotFound                    = 500
    case appErrorUnzipFileAssetBundle               = 501
    case appErrorDownloadAssetBundle                = 502
    
    case appErrorNeedSignInForFavoite               = 600
    case appErrorNeedSignInForVote                  = 601
    case appErrorNeedSignInForFeedback              = 602
    
    case appErrorNeedViewForVote                    = 603
    case appErrorNeedViewForFeedback                = 604
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
