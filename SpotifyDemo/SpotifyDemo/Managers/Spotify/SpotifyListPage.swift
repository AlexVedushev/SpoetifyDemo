//
//  SpotifyListPage.swift
//  SpotifyDemo
//
//  Created by Alexey Vedushev on 19/02/2018.
//  Copyright © 2018 Alexey Vedushev. All rights reserved.
//

import Foundation

class SpotifyListPage<T: SPTListPage, S: SPTJSONObject> {
    private var playlistListPage: T!
    var playlistList: [S] = []
    
    init(playlistListPage: T) {
        self.playlistListPage = playlistListPage
        self.playlistList = playlistListPage.items as! [S]
    }
    
    var accessToken: String? {
        return SpotifyManager.share.accessToken
    }
    
    func getNextPagePlaylistList(completion: @escaping ((_ error: Error?, _ playlistList: [Any])->())) {
        guard let playlistListPage = playlistListPage, let accessToken = accessToken else {
            completion(nil, [])
            return
        }
        var block: ((Bool)->Void)!
        
        block = {(retryOnError: Bool) in
            playlistListPage.requestNextPage(withAccessToken: accessToken) {[weak self] (error, data) in
                guard let sself = self else {return}
                SpotifyManager.errorHandler(error, retryOnError: retryOnError, data: data as? SPTListPage, operation: block, completion: {[weak sself] (error, data) in
                    guard let ssself = sself else {return}
                    
                    if error == nil {
                        ssself.playlistListPage = data as! T
                        ssself.playlistList.append(contentsOf: ssself.playlistListPage.items as! [S])
                    }
                    completion(error, ssself.playlistList)
                })
            }
        }
        block(true)
    }
    
    private func getPlaylistListFrom( _ listPage: SPTListPage) -> [SPTPartialPlaylist] {
        guard let playListList = listPage as? SPTPlaylistList, let playlistItems = playListList.items as? [SPTPartialPlaylist] else {
            return []
        }
        return playlistItems
    }
}
