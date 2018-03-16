//
//  SPTPatialTrack+Extension.swift
//  SpotifyDemo
//
//  Created by Alexey Vedushev on 15/03/2018.
//  Copyright © 2018 Alexey Vedushev. All rights reserved.
//

import Foundation

extension SPTPartialTrack {
    var artistsNameString: String? {
        guard let artists = self.artists as? [SPTPartialArtist] else {return nil}
        return artists.map{$0.name!}.joined(separator: ", ")
    }
}
