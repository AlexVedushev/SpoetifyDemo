//
//  SpotifyTrackInfoListPage.swift
//  SpotifyDemo
//
//  Created by Alexey Vedushev on 14/03/2018.
//  Copyright © 2018 Alexey Vedushev. All rights reserved.
//

import Foundation
import ORCoreData

protocol SpotifyTrackList: class {
    func getNextPageIfAvailable(completion: @escaping ((Error?, [CDTrack]) -> ()))
}

class SpotifyTrackInfoListPage: BaseManager, SpotifyTrackList {
    private var listPage: SPTListPage
    private var trackList = [CDTrack]()
    
    init(listPage: SPTListPage) {
        self.listPage = listPage
    }
    
    private var accessToken: String? {
        return SpotifyManager.share.accessToken
    }
    
    func getNextPageIfAvailable(completion: @escaping ((Error?, [CDTrack]) -> ())) {
        guard !trackList.isEmpty else {
            getFirstPage(completion: { (trackList) in
                completion(nil, trackList)
            })
            return
        }
        
        guard listPage.hasNextPage else {
            completion(nil, trackList)
            return
        }
        
        guard let accessToken = accessToken else {
            completion(nil, [])
            return
        }
        var getTrackBlock: ((Bool)->Void)!
        
        getTrackBlock = {[weak self](retryOnError: Bool) in
            self?.listPage.requestNextPage(withAccessToken: accessToken) {[weak self] (error, data) in
                guard let sself = self else {return}
                SpotifyManager.errorHandler(error, retryOnError: retryOnError, data: data as? SPTListPage, operation: getTrackBlock, completion: {[weak sself] (error, data) in
                    guard let ssself = sself else {return}
                    
                    guard error == nil else {
                        print(error!)
                        completion(error, [])
                        return
                    }
                    ssself.listPage = data!
                    
                    ssself.fillInfoForListPageTracks(completion: { (trackList) in
                        ssself.trackList.append(contentsOf: trackList)
                        completion(nil, ssself.trackList)
                    })
                })
            }
        }
        getTrackBlock(true)
    }
    
    private func getFirstPage(completion: @escaping([CDTrack])->Void) {
        fillInfoForListPageTracks {[weak self] (trackList) in
            guard let sself = self else {return}
            sself.trackList = trackList
            completion(trackList)
        }
    }
    
    private func fillInfoForListPageTracks(completion: @escaping ([CDTrack])->Void) {
        guard let itemList = listPage.items as? [SPTPartialTrack] else {return}
        
        updateTrackListInLocalStorageFrom(itemList: itemList) {[weak self] (trackList) in
            guard let sself = self else {return}
            sself.updateFeatureInfoFor(ids: itemList.map{$0.identifier!}, completion: completion)
        }
    }
    
    private func updateFeatureInfoFor(ids: [String], completion: @escaping ([CDTrack])->Void) {
        SpotifyFeaturesTrackManager.shared.downloadFeatureForSeveralTracks(ids: ids, completion: {(trackList, error) in
            guard let trackList = trackList else {
                completion([])
                return
            }
            completion(trackList)
        })
    }
    
    private func updateTrackListInLocalStorageFrom(itemList: [SPTPartialTrack], completion: @escaping ([CDTrack])->Void) {
        ORCoreDataSaver.sharedInstance.saveData({ (localContext, cancelSaving) in
            for item in itemList {
                let track = ORCoreDataEntityFinderAndCreator(localContext).findOrCreateEntityOfType(CDTrack.self, byAttribute: kKeyUid, withValue: item.identifier)
                track.name = item.name
                track.albumName = item.album.name
                track.artistName = item.artistsNameString
                track.service = MusicServiceEnum.spotify
            }
        }) {[weak self] in
            guard let sself = self else {return}
            var resultList = [CDTrack]()
            
            for item in itemList {
                guard let track = ORCoreDataEntityFinderAndCreator(sself.defaultContext).findEntityOfType(CDTrack.self, byAttribute: kKeyUid, withValue: item.identifier!) else {continue}
                resultList.append(track)
            }
            completion(resultList)
        }
    }
}
