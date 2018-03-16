//
//  CDTrack+CoreDataProperties.swift
//  SpotifyDemo
//
//  Created by Alexey Vedushev on 16/03/2018.
//  Copyright © 2018 Alexey Vedushev. All rights reserved.
//
//

import Foundation
import CoreData


extension CDTrack {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDTrack> {
        return NSFetchRequest<CDTrack>(entityName: "CDTrack")
    }

    @NSManaged public var albumName: String?
    @NSManaged public var artistName: String?
    @NSManaged public var name: String?
    @NSManaged public var serviceName: String?
    @NSManaged public var feature: CDTrackFeature?

}
