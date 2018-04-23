//
//  InternalTrack.swift
//  SpotifyDemo
//
//  Created by Alexey Vedushev on 23/04/2018.
//  Copyright © 2018 Alexey Vedushev. All rights reserved.
//

import Foundation

struct InternalTrack: Codable {
    let id: String
    let idInMusicService: String
    let title: String
    let artist: String
    let bpm: Int
    let duration: TimeInterval
}
