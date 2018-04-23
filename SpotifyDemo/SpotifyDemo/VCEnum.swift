//
//  VCEnum.swift
//  Spotify Demo
//
//  Created by Alexey Vedushev on 13/02/2018.
//  Copyright © 2018 Alexey Vedushev. All rights reserved.
//

import Foundation

enum VCEnum {
    case tracklist
    case playListList
    case player
    
    fileprivate var storyboardName: String {
        switch self {
        case .tracklist, .playListList, .player:
            return "Main"
        }
    }
    
    fileprivate var vcName: String {
        return "\(self)"
    }
    
    var vc: UIViewController {
        return storyboard.instantiateViewController(withIdentifier: vcName)
    }
    
    var storyboard: UIStoryboard {
        return UIStoryboard(name: storyboardName, bundle: nil)
    }
}
