////
////  AudioFeaturesListMapObj.swift
////  SpotifyDemo
////
////  Created by Alexey Vedushev on 05/03/2018.
////  Copyright © 2018 Alexey Vedushev. All rights reserved.
////
//
//import Foundation
//import ObjectMapper
//
//class AudioFeaturesListMapObj: Mappable {
//    required init?(map: Map) {
//        print(map)
//    }
//    
//    var featuresList: Array<AudioFeaturesObj>?
//    var firstEnergy: Double?
//    
//    var description: String {
//        return "featuresList count: \(featuresList?.count) \n firstEnergy = \(firstEnergy)"
//    }
//    
//    func mapping(map: Map) {
////        featuresList <- map["audio_features"]
//        featuresList <- map["audio_features"]
//    }
//}
//
//class AudioFeaturesArrayTransformType: TransformType {
//    typealias Object = [AudioFeaturesObj]
//    typealias JSON = [[String : Any]]
//    
//    func transformFromJSON(_ value: Any?) -> [AudioFeaturesObj]? {
//        var resultList = [AudioFeaturesObj]()
//        
//        if let featuresList = value as? [[String: Any]] {
//            for feature in featuresList {
//                if let feature = AudioFeaturesObj(JSON: feature) {
//                    resultList.append(feature)
//                }
//            }
//        }
//        return resultList
//    }
//    
//    func transformToJSON(_ value: [AudioFeaturesObj]?) -> [[String : Any]]? {
//        guard let featuresList = value else {return nil}
//        var resultList = [[String : Any]]()
//        
//        for features in featuresList {
//            resultList.append(features.toJSON())
//        }
//        return resultList
//    }
//}
//
//class AudioFeaturesObj: Mappable {
//     var danceability: Double?
//     var energy: Double?
//     var key: Int?
//     var loudness: Double?
//     var mode: Int?
//     var speechiness: Double?
//     var acousticness: Double?
//     var instrumentalness: Double?
//     var liveness: Double?
//     var valence: Double?
//     var tempo: Double?
//     var trackHref: String?
//     var analysisUrl: String?
//     var durationMs: Int?
//     var timeSignature: Int?
//    
//    required init?(map: Map) {
//        print(map)
//    }
//    
//    func mapping(map: Map) {
//        danceability <- map["danceability"]
////        energy <- map["energy"]
////        key <- map["key"]
////        loudness <- map["loudness"]
////        mode <- map["mode"]
////        speechiness <- map["speechiness"]
////        acousticness <- map["acousticness"]
////        instrumentalness <- map["instrumentalness"]
////        liveness <- map["liveness"]
////        valence <- map["valence"]
////        tempo <- map["tempo"]
////        trackHref <- map["track_href"]
////        analysisUrl <- map["analysis_url"]
////        durationMs <- map["duration_ms"]
////        timeSignature <- map["time_signature"]
//    }
//    
//    
//}

