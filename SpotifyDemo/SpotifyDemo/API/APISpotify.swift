//
//  APIFeatureTrack.swift
//  Spotify Demo
//
//  Created by Alexey Vedushev on 13/02/2018.
//  Copyright © 2018 Alexey Vedushev. All rights reserved.
//

import Foundation
import Alamofire

class APISpotify: APIBase, APISpotifyProtocol {
    
    private enum Router: URLRequestConvertible {
        case audioFeatures(idsList: [String])
        case audioAnalysis(id: String)
        
        
        var path: String {
            switch self {
            case .audioFeatures:
                return "audio-features"
            case .audioAnalysis:
                return "audio-analysis"
            }
        }
        
        var method: Alamofire.HTTPMethod {
            switch self {
            case .audioFeatures, .audioAnalysis:
                return .get
            }
        }
        
        
        
        func asURLRequest() throws -> URLRequest {
            var url: URL!
            var urlRequest: URLRequest!
            url = URL(string: appBaseURL)!
            url.appendPathComponent(path)
            
            switch self {
            case .audioFeatures(let idsList):
                url = url.urlByAppendingQueryParameters(parameters: ["ids" : idsList.joined(separator: ",")])
            case .audioAnalysis(let id):
                url = url.urlByAppendingQueryParameters(parameters: ["id" : id])
            }
            urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = method.rawValue
            return try JSONEncoding.default.encode(urlRequest)
        }
    }
    
    //MARK: - API methdos
    
    func getFeatureTrack(ids: [String], completion: @escaping  DataResponseBlock) {
        request(Router.audioFeatures(idsList: ids)) { (data, error) in
            completion(data, error)
        }
    }
    
    func getAudioAnalysisFor(id: String, completion: @escaping  DataResponseBlock) {
        request(Router.audioAnalysis(id: id)) { (data, error) in
            completion(data, error)
        }
    }
    
}
