//
//  InternalPlaylist.swift
//  SpotifyDemo
//
//  Created by Alexey Vedushev on 23/04/2018.
//  Copyright © 2018 Alexey Vedushev. All rights reserved.
//

import Foundation

struct InternalPlaylist: Codable {
    let id: String
    let images: [URL]
    let title: String
    let tracks: [InternalTrack]
}
