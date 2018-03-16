//
//  APIAdapter.swift
//  Spotify Demo
//
//  Created by Alexey Vedushev on 12/02/2018.
//  Copyright © 2018 Alexey Vedushev. All rights reserved.
//

import Foundation
import Alamofire

class APIAdapter: RequestAdapter {
    private let accessToken: String
    
    init(accessToken: String) {
            self.accessToken = accessToken
    }
    
    //MARK: - RequestAdapter
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        let requestString = urlRequest.url?.absoluteString ?? ""
        
        if accessToken.count > 0 {
            let value = /*(urlRequest.url?.absoluteString ?? "").contains(kGraphQLServerBaseURLString) ? accessToken :*/ "Bearer " + accessToken
            urlRequest.setValue(value, forHTTPHeaderField: "Authorization")
        }
        
        if !requestString.contains("oauth/token"), urlRequest.httpMethod == Alamofire.HTTPMethod.post.rawValue {
//            let value = requestString.contains(kGraphQLServerBaseURLString) ? "application/json" : "application/x-www-form-urlencoded"
            let value = "application/json"
            urlRequest.setValue(value, forHTTPHeaderField: "Content-Type")
            urlRequest.setValue(value, forHTTPHeaderField: "Accept")
        }
        
        return urlRequest
    }
}
