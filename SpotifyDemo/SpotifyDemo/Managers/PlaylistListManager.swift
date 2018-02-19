//
//  PlaylistListManager.swift
//  SpotifyDemo
//
//  Created by Alexey Vedushev on 19/02/2018.
//  Copyright © 2018 Alexey Vedushev. All rights reserved.
//

import Foundation

class PlaylistListManager {
    private var user: SPTUser?
    private var playlistListPage: SPTPlaylistList?
    
    var accessToken: String? {
        return SpotifyManager.share.accessToken
    }
    
    
}
