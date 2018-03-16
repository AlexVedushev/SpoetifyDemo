//
//  SpotifyFeaturesTrackManager.swift
//  SpotifyDemo
//
//  Created by Alexey Vedushev on 05/03/2018.
//  Copyright © 2018 Alexey Vedushev. All rights reserved.
//

import Foundation
import ObjectMapper
import ORCoreData
import MagicalRecord

class SpotifyFeaturesTrackManager: BaseManager {
    static let shared = SpotifyFeaturesTrackManager()
    
    private let api: APIFeatureTrackProtocol = APIFeatureTrack()
    
    func downloadFeatureForSeveralTracks(ids: [String], completion:@escaping ((_ resultList: [CDTrack]?, _ error: Error?)->Void)) {
        let forDownloadIdList = getIdListForDownloadFeaturesFrom(ids: ids)
        
        guard !forDownloadIdList.isEmpty else {
            let trackList = CDTrack.getLocalTrackListBy(ids: ids)
            completion(trackList, nil)
            return
        }
        
        var block: ((Bool)->Void)!
        block = {[weak self](retryOnError: Bool) in
            self?.api.getFeatureTrack(ids: forDownloadIdList, completion: { (data, error) in
                SpotifyManager.errorHandler(error, retryOnError: retryOnError, data: data, operation: block, completion: {[weak self] (error, data) in
                    guard let sself = self else {return}
                    
                    guard error == nil else {
                        print(error!)
                        completion(nil, error)
                        return
                    }
                    
                    guard let data = data, let features = try? JSONDecoder().decode(FeatureTrackListMapper.self, from: data) else {
                        completion(nil, nil)
                        return
                    }
                    sself.updateLocalStore(featureList: features, completion: {[weak self] (cdTracks) in
                        guard let sself = self else {return}
                        var resultList = [CDTrack]()
                        
                        for id in ids {
                            guard let track = ORCoreDataEntityFinderAndCreator(sself.defaultContext).findEntityOfType(CDTrack.self, byAttribute: kKeyUid, withValue: id) else {continue}
                            resultList.append(track)
                        }
                        completion(resultList, nil)
                    })
                })
            })
        }
        block(true)
    }
    
    private func updateLocalStore(featureList: FeatureTrackListMapper, completion: (([CDTrack])->Void)? = nil) {
        guard let featureMapperList = featureList.featureList else {
            completion?([])
            return
        }
        ORCoreDataSaver.sharedInstance.saveData({ (localContext, cancelSaving) in
            for featureMapper in featureMapperList {
                guard let track = ORCoreDataEntityFinderAndCreator(localContext).findEntityOfType(CDTrack.self, byAttribute: kKeyUid, withValue: featureMapper.id) else {continue}
                let feature = track.feature ?? CDTrackFeature.mr_createEntity(in: localContext)
                feature?.bpm = featureMapper.tempo
                feature?.duration = (featureMapper.durationMS / 1000)
                track.feature = feature
            }
        }) {[weak self] in
            guard let sself = self else {
                completion?([])
                return
            }
            var resList = [CDTrack]()
            
            for feature in featureMapperList {
                guard let track = ORCoreDataEntityFinderAndCreator(sself.defaultContext).findEntityOfType(CDTrack.self, byAttribute: kKeyUid, withValue: feature.id) else {continue}
                resList.append(track)
            }
            completion?(resList)
        }
    }
    
    private func getIdListForDownloadFeaturesFrom(ids: [String]) -> [String] {
        var resultList = [String]()
        
        for id in ids {
            if ORCoreDataEntityFinderAndCreator(defaultContext).findEntityOfType(CDTrack.self, byAttribute: kKeyUid, withValue: id)?.feature == nil {
                resultList.append(id)
            }
        }
        return resultList
    }
}
