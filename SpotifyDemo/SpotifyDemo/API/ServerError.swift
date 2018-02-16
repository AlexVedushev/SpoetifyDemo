//
//  ServerError.swift
//  Spotify Demo
//
//  Created by Alexey Vedushev on 13/02/2018.
//  Copyright © 2018 Alexey Vedushev. All rights reserved.
//

import Foundation

enum ServerErrorCode : Int {
    
    case error  = 999
    case errorWithInvalidDescriptionFormat  = 1000
}

class ServerError: BaseError {
    
    enum ErrorId: String {
        case invalid_token
    }
    
    static let kErrorDomain = "serverAPIError"
    static let kLocalizationPrefix = "server-error"
    static let kCategoryString = "Server Error"
    
    private(set)var errorId: String?
    
    static func errorWithCode(_ code: ServerErrorCode, description: String, errorId: String? = nil) -> ServerError {
        let err: ServerError
        if code == .errorWithInvalidDescriptionFormat {
            err = ServerError(domain: kErrorDomain, code: code.rawValue,
                              localizationPrefix: kLocalizationPrefix, categoryString: kCategoryString, alwaysUseCategoryStringAsPrefix: true)
        } else {
            err = ServerError(domain: kErrorDomain, code: code.rawValue, customDescription: "\(kCategoryString): \(description)")
        }
        err.errorId = errorId
        return err
    }
}
