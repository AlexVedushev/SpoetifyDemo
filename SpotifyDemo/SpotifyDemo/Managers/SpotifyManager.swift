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
    
    static let share = SpotifyManager(clientID: "ca19f9334ea84e85a4194cc096dea9f1", redirectURL: URL(string: "spotify-ios-demo-login://")!, sessionUserDefaultsKey: "current session", requestedScopes: [SPTAuthStreamingScope])
    
    init(clientID: String, redirectURL: URL, sessionUserDefaultsKey: String, requestedScopes: [Any]) {
        auth = SPTAuth.defaultInstance()
        player = SPTAudioStreamingController.sharedInstance()
        auth.clientID = clientID
        auth.redirectURL = redirectURL
        
        auth.sessionUserDefaultsKey = sessionUserDefaultsKey
        auth.requestedScopes =  requestedScopes
//        player.delegate = self
    }
    
    var window: UIWindow?
    var auth: SPTAuth!
    var player: SPTAudioStreamingController!
    
    weak var authViewController: SFSafariViewController?
    
    private var user: SPTUser?
    private var playlistListPage: SPTPlaylistList?
    
    
    var accessToken: String? {
        return SPTAuth.defaultInstance().session.accessToken
    }
    
    var isValidSession: Bool {
        guard let session = SPTAuth.defaultInstance().session else {return false}
        return session.isValid()
    }
    
    // MARK: - Playlist
    
    func getUserPlaylists(_ sender: UIViewController? = nil, completion: @escaping ((_ error: Error?, _ playlistList: [SPTPartialPlaylist])->())) {
        guard !updateSessionIfNeed(sender) else {return}
        
        if let user = user {
           getPlaylistListForUser(name: user.canonicalUserName, completion: completion)
        } else {
            getCurrentUser(completion: {[weak self] (error, user) in
                guard let sself = self, let user = user else {
                    completion(error, [])
                    return
                }
                sself.getPlaylistListForUser(name: user.canonicalUserName, completion: completion)
            })
        }
    }
    
    func getPlaylistListForUser(name: String, completion: @escaping ((_ error: Error?, _ playlistList: [SPTPartialPlaylist])->())) {
        SPTPlaylistList.playlists(forUser: name, withAccessToken: accessToken!, callback: {[weak self] (error, data) in
            guard error == nil else {
                completion(error, [])
                print(error)
                return
            }
            guard let playListList = data as? SPTPlaylistList, let playlistItems = playListList.items as? [SPTPartialPlaylist] else {
                completion(error, [])
                return
            }
            self?.playlistListPage = playListList
            completion(nil, playlistItems)
        })
    }
    
    //MARK: - user request
    
    func getCurrentUser(_ sender: UIViewController? = nil, completion: @escaping ((_ error: Error?, _ user: SPTUser?)->())) {
        guard !updateSessionIfNeed(sender) else {return}
        
        SPTUser.requestCurrentUser(withAccessToken: accessToken!) {[weak self] (error, user) in
            guard error == nil else {
                print(error)
                completion(error, nil)
                return
            }
            self?.user = user as? SPTUser
            completion(error, user as? SPTUser)
        }
    }
    
    //MARK: - AuthViewControllerDelegate
    
    func authDidDismiss() {
        print("authDidDismiss")
    }
    
    /**
    Determine is need update session, and updated session
    */
    private func updateSessionIfNeed(_ sender: UIViewController? = nil) -> Bool {
        if !isValidSession {
            showAuthentificationWebPage(sender)
        }
        return !isValidSession
    }
    
    
    func canHandleAuth(url: URL) -> Bool {
        if auth.canHandle(url) {
            authViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            authViewController = nil
            auth.handleAuthCallback(withTriggeredAuthURL: url, callback: {[weak self] (error, session) in
                if let auth = self?.auth,  session != nil {
                    self?.player.login(withAccessToken: auth.session.accessToken)
                }
            })
            return true
        }
        return false
    }
    
    func showAuthentificationWebPage(_ sender: UIViewController? = nil) {
        guard let authURL = SPTAuth.defaultInstance().spotifyWebAuthenticationURL() else {return}
        let authViewController = SFSafariViewController(url: authURL)
        self.authViewController = authViewController
        sender?.present(authViewController, animated: true, completion: nil)
    }
    
    func renewAccessToken() { // need token refresh service
        guard let sesion = SPTAuth.defaultInstance().session else {return}
        SPTAuth.defaultInstance().renewSession(sesion) { (error, session) in
            print("erorr = \(error)")
            print("session = \(session)")
        }
    }
}
