//
//  APIBase.swift
//  Spotify Demo
//
//  Created by Alexey Vedushev on 12/02/2018.
//  Copyright © 2018 Alexey Vedushev. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


public typealias JSONResponseBlock = (JSON?, NSError?) -> Void
public typealias BooleanBlock = (Bool, NSError?) -> Void
public typealias StringBlock = (String?, NSError?) -> Void

let kPrintAllApiResponses = true


class APIBase {
    
    var trackErrors = true
    
    // MARK: - API Methods
    
    func request(_ urlRequest: URLRequestConvertible, credential: URLCredential? = nil, completion: @escaping JSONResponseBlock) {
        
        Alamofire.request(urlRequest)
            .validate()
            .authenticate(usingCredential: credential ?? URLCredential())
            .response { [weak self] (response) in
                
                #if DEBUG
                    if kPrintAllApiResponses {
                        var debugStr = " Method: \(response.request?.httpMethod ?? String())\n Request to URL: \(response.request?.url?.absoluteString ?? String())\n Headers:\(response.request?.allHTTPHeaderFields ?? [:])"
                        if let body = response.request?.httpBody, body.count > 0 {
                            debugStr += "\nHTTP body:\(String(data: body, encoding: String.Encoding.utf8) ?? String())"
                        }
                        
                        print("\nRequest:\n \(debugStr)\n ")
                    }
                #endif
                
                if let error = response.error {
                    var outError: NSError?
                    
                    if let afError = error as? AFError, afError.isResponseSerializationError {
                        outError = AppError.errorWithCode(.appErrorInvalidResponse)
                    } else {
                        let serverError = self?.errorDataHandler(response.data)
                        outError = serverError
                        if serverError?.errorId == ServerError.ErrorId.invalid_token.rawValue {
                            NotificationCenter.default.post(name: AppNotification.AppNotificationServerErrorInvalidToken.name, object: nil)
                        }
                    }
                    
                    if outError == nil {
                        outError = error as NSError
                    }
                    
                    if self?.trackErrors == true, let outError = outError {
                        Logger.error(outError)
                    }
                    
                    completion(nil, outError)
                    
                } else if let data = response.data {
                    let json = JSON(data: data)
                    
                    #if DEBUG
                        if kPrintAllApiResponses {
                            print("\nResponse:\n \(json)\n ")
                        }
                    #endif
                    
                    completion(json, nil)
                }
        }
    }
    
    func errorDataHandler(_ data: Data?) -> ServerError? {
        guard let data = data else {
            return ServerError.errorWithCode(.errorWithInvalidDescriptionFormat, description: "")
        }
        
        do {
            if let jsonDict = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary {
                var errorDescriptionArray = [String]()
                var errorId: String?
                if let status = jsonDict["status"] {
                    errorDescriptionArray.append("\(status)")
                }
                if let error = jsonDict["error"] {
                    errorId = error as? String
                    errorDescriptionArray.append("\(error)")
                }
                if let message = jsonDict["message"] {
                    errorDescriptionArray.append("(\(message))")
                } else if let message = jsonDict["error_description"] {
                    errorDescriptionArray.append("(\(message))")
                }
                let errorDescription = errorDescriptionArray.joined(separator: " ")
                return ServerError.errorWithCode(.error, description: errorDescription, errorId: errorId)
            } else {
                return ServerError.errorWithCode(.errorWithInvalidDescriptionFormat, description: "")
            }
        } catch {
            return nil  // some kind of a system error
        }
    }
    
    static func setAccessToken(_ accessToken: String) {
        SessionManager.default.adapter = APIAdapter(accessToken: accessToken)
    }
}

extension URL {
    func urlByAppendingQueryParameters(parameters: [String: String]?) -> URL {
        guard let parameters = parameters, let urlComponents = NSURLComponents(url: self as URL, resolvingAgainstBaseURL: true) else {
            return self
        }
        
        var mutableQueryItems: [URLQueryItem] = urlComponents.queryItems ?? []
        
        mutableQueryItems.append(contentsOf: parameters.map({ (tuple: (key: String, value: String)) -> URLQueryItem in
            return URLQueryItem(name: tuple.key, value: tuple.value)
        }))
        
        urlComponents.queryItems = mutableQueryItems
        
        return urlComponents.url!
    }
    
}
