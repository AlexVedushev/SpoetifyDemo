//
//  SpotifyManager.swift
//  SpotifyDemo
//
//  Created by Alexey Vedushev on 16/02/2018.
//  Copyright © 2018 Alexey Vedushev. All rights reserved.
//

import Foundation
import SafariServices

enum SpotifyError: Error {
    case InvalidSession
}

class SpotifyManager {
    
    static var share: SpotifyManager{
        return SpotifyManager()
    }
    
    var user: SPTUser?
    
    var accessToken: String? {
        return SPTAuth.defaultInstance().session.accessToken
    }
    
    var isValidSession: Bool {
        guard let session = SPTAuth.defaultInstance().session else {return false}
        return session.isValid()
    }
    
    // MARK: - Playlist
    
    func getUserPlaylists() {
        
//        if user == nil {
//            SPTUser.requestCurrentUser(withAccessToken: <#T##String!#>, callback: <#T##SPTRequestCallback!##SPTRequestCallback!##(Error?, Any?) -> Void#>)
//        }
    }
    
    /**
    Return is need update session, and updated session
    */
    private func updateSessionIfNeed() -> Bool {
        var result = isValidSession
        
        return result
    }
    
    
    private func showAuthentificationWebPage(_ sender: UIViewController) {
        guard let authURL = SPTAuth.defaultInstance().spotifyWebAuthenticationURL() else {return}
        let authViewController = SFSafariViewController(url: authURL)
        
        if let sfsDelegate = sender as? SFSafariViewControllerDelegate {
            authViewController.delegate = sfsDelegate
        }
        sender.present(authViewController, animated: true, completion: nil)
    }
    
    func renewAccessToken() { // need token refresh service
        guard let sesion = SPTAuth.defaultInstance().session else {return}
        SPTAuth.defaultInstance().renewSession(sesion) { (error, session) in
            print("erorr = \(error)")
            print("session = \(session)")
        }
    }
}
