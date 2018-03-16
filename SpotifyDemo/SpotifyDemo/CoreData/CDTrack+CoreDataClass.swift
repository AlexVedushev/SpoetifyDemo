//
//  CDTrack+CoreDataClass.swift
//  SpotifyDemo
//
//  Created by Alexey Vedushev on 14/03/2018.
//  Copyright © 2018 Alexey Vedushev. All rights reserved.
//
//

import Foundation
import CoreData
import ORCoreData

@objc(CDTrack)
public class CDTrack: CDBaseEntity {
    var service: MusicServiceEnum? {
        get {
            return MusicServiceEnum(rawValue: serviceName ?? "")
        }
        set {
            serviceName = newValue?.rawValue
        }
    }
    
    static func getLocalTrackListBy(ids: [String]) -> [CDTrack] {
        var trackList = [CDTrack]()
        
        for id in ids {
            if let track = ORCoreDataEntityFinderAndCreator(NSManagedObjectContext.mr_default()).findEntityOfType(CDTrack.self, byAttribute: kKeyUid, withValue: id) {
                trackList.append(track)
            }
        }
        return trackList
    }
}
