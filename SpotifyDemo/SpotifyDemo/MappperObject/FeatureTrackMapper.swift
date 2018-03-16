//
//  FeatureTrack.swift
//  SpotifyDemo
//
//  Created by Alexey Vedushev on 12/03/2018.
//  Copyright © 2018 Alexey Vedushev. All rights reserved.
//

import Foundation

struct FeatureTrackMapper: Codable {
    var id: String
    var tempo: Double
    var durationMS: Float
    
    enum CodingKeys: String, CodingKey {
        case id
        case tempo
        case durationMS = "duration_ms"
    }
}

struct FeatureTrackListMapper: Codable {
    var featureList: [FeatureTrackMapper]?
    
    enum CodingKeys: String, CodingKey {
        case featureList = "audio_features"
    }
}
