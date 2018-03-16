//
//  SpotifyListPage.swift
//  SpotifyDemo
//
//  Created by Alexey Vedushev on 19/02/2018.
//  Copyright © 2018 Alexey Vedushev. All rights reserved.
//

import Foundation

class SpotifyListPage<T: SPTListPage, S: SPTJSONObject> {
    var listPage: T!
    var itemList: [S] = []
    
    init(listPage: T) {
        self.listPage = listPage
        self.itemList = (listPage.items as? [S]) ?? [S]()
    }
    
    var accessToken: String? {
        return SpotifyManager.share.accessToken
    }
    
    func getNextPage(completion: @escaping ((_ error: Error?, _ itemList: [S])->())) {
        guard let playlistListPage = listPage, let accessToken = accessToken else {
            completion(nil, [])
            return
        }
        guard listPage.hasNextPage else {
            completion(nil, itemList)
            return
        }
        var block: ((Bool)->Void)!
        
        block = {(retryOnError: Bool) in
            playlistListPage.requestNextPage(withAccessToken: accessToken) {[weak self] (error, data) in
                guard let sself = self else {return}
                SpotifyManager.errorHandler(error, retryOnError: retryOnError, data: data as? SPTListPage, operation: block, completion: {[weak sself] (error, data) in
                    guard let ssself = sself else {return}
                    
                    if error == nil {
                        ssself.listPage = data as! T
                        ssself.itemList.append(contentsOf: ssself.listPage.items as! [S])
                    }
                    completion(error, ssself.itemList)
                })
            }
        }
        block(true)
    }
}
