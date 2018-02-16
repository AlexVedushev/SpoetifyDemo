//
//  APIFeatureTrack.swift
//  Spotify Demo
//
//  Created by Alexey Vedushev on 13/02/2018.
//  Copyright © 2018 Alexey Vedushev. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIFeatureTrack: APIBase {
    
    private enum Router: URLRequestConvertible {
        case audioFeatures(idsList: [String])
        
        var path: String {
            switch self {
            case .audioFeatures:
                return "audio-features"
            default:
                return ""
            }
        }
        
        var method: Alamofire.HTTPMethod {
            switch self {
            case .audioFeatures:
                return .post
            default:
                return .post
            }
        }
        
        
        
        func asURLRequest() throws -> URLRequest {
            var url: URL!
            var urlRequest: URLRequest!
            
            switch self {
            case .audioFeatures(let idsList):
                url = URL(string: appBaseURL)!.urlByAppendingQueryParameters(parameters: ["ids" : idsList.joined(separator: ",")])
                urlRequest = URLRequest(url: url)
            }
            urlRequest.httpMethod = method.rawValue
            return try JSONEncoding.default.encode(urlRequest)
        }
    }
    
    //MARK: - API methdos
    
    func getFeatureTrack(ids: [String], completion: @escaping  JSONResponseBlock) {
        request(Router.audioFeatures(idsList: ids)) { (json, error) in
            completion(json, error)
        }
    }
    
}
