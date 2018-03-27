//
//  SpotifyPlaylistSnapshot.swift
//  SpotifyDemo
//
//  Created by Alexey Vedushev on 13/03/2018.
//  Copyright © 2018 Alexey Vedushev. All rights reserved.
//

import Foundation

protocol SpotifyPlaylist: class {
    func getNextPageIfAvailable(completion: @escaping ([CDTrack])->Void)
}

class SpotifyPlaylistSnapshot: SpotifyPlaylist {
    private let playlistSnapshot: SPTPlaylistSnapshot
    private var trackListPage: SpotifyTrackList?
    
    
    init(snapshot: SPTPlaylistSnapshot) {
        self.playlistSnapshot = snapshot
    }
    
    func getNextPageIfAvailable(completion: @escaping ([CDTrack])->Void) {
        if trackListPage == nil {
            trackListPage = SpotifyTrackInfoListPage(listPage: playlistSnapshot.firstTrackPage)
        }
        trackListPage?.getNextPageIfAvailable { (error, trackList) in
            completion(trackList)
        }
        
    }
    
    
}
