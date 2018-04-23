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
    var partialPlaylist: SPTPartialPlaylist?
    
    init(snapshot: SPTPlaylistSnapshot, partialPlaylist: SPTPartialPlaylist) {
        self.playlistSnapshot = snapshot
        self.partialPlaylist = partialPlaylist
    }
    
    func getNextPageIfAvailable(completion: @escaping ([CDTrack])->Void) {
        if trackListPage == nil {
            trackListPage = SpotifyTrackInfoListPage(listPage: playlistSnapshot.firstTrackPage)
        }
        trackListPage?.getNextPageIfAvailable { (error, trackList) in
            completion(trackList)
            self.createJSON(trackList: trackList)
        }
    }
    
    
    func createJSON(trackList: [CDTrack]) {
        let playlistTitle = partialPlaylist?.name ?? getErrorParsing(name: "playlist name")
        let playListId = partialPlaylist?.uri.absoluteString ?? getErrorParsing(name: "playlist uri")
        let urlComp = URLComponents(string: (partialPlaylist?.uri?.absoluteString)!)
        var internalTtrackList: [InternalTrack] = []
        
        for item in trackList {
            let track = InternalTrack(id: item.uid ?? "", idInMusicService: MusicServiceEnum.spotify.rawValue, title: item.name ?? "", artist: item.artistName ?? "", bpm: Int(item.feature?.bpm ?? 0), duration: TimeInterval(item.feature?.duration ?? 0))
            internalTtrackList.append(track)
        }
        let playList = InternalPlaylist(id: playListId, title: playlistTitle, tracks: internalTtrackList)
        guard let data = try? JSONEncoder().encode(playList) else {return}
        let jsonStr = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        print(jsonStr)
    }
    
    func getErrorParsing(name: String) -> String{
        return "error parsing \(name)"
    }
    
}
