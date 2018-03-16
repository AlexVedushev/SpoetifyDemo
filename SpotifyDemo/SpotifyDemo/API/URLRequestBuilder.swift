//
//  URLTequestBuilder.swift
//  Spotify Demo
//
//  Created by Alexey Vedushev on 13/02/2018.
//  Copyright © 2018 Alexey Vedushev. All rights reserved.
//

import Foundation

class URLRequestBuilder {
    
    static func makeURLRequest(_ url: URL) -> URLRequest {
        let urlRequest = URLRequest(url: url, timeoutInterval: kURLRequestTimeoutInterval)
        return urlRequest
    }
}
