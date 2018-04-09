//
//  APIProtocol.swift
//  SpotifyDemo
//
//  Created by Alexey Vedushev on 05/03/2018.
//  Copyright © 2018 Alexey Vedushev. All rights reserved.
//

import Foundation

protocol APISpotifyProtocol: class {
    func getFeatureTrack(ids: [String], completion: @escaping  DataResponseBlock)
    func getAudioAnalysisFor(id: String, completion: @escaping  DataResponseBlock)
}
