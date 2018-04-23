//
//  SpotifyManager.swift
//  SpotifyDemo
//
//  Created by Alexey Vedushev on 16/02/2018.
//  Copyright © 2018 Alexey Vedushev. All rights reserved.
//

import Foundation
import SafariServices
import ORCommonCode_Swift

typealias PlaylistListPageResponse = ((_ error: Error?, _ listPage: SpotifyListPage<SPTPlaylistList, SPTPartialPlaylist>?)->())
typealias TrackListPageResponse = ((_ error: Error?, _ listPage: SpotifyListPage<SPTListPage, SPTPartialTrack>?)->())
typealias PlaylistSnapshotResponse = ((_ error: Error?, _ snapshot: SpotifyPlaylistSnapshot?)->())

class SpotifyManager {
    
    static let share = SpotifyManager(clientID: "a550e3e46ce84b0c85ca2003affebf82", redirectURL: URL(string: "spotify-ios-demo-login://")!, sessionUserDefaultsKey: "current session", requestedScopes: [SPTAuthStreamingScope])
    
    init(clientID: String, redirectURL: URL, sessionUserDefaultsKey: String, requestedScopes: [Any]) {
        auth = SPTAuth.defaultInstance()
        player = SPTAudioStreamingController.sharedInstance()
        auth.clientID = clientID
        auth.redirectURL = redirectURL
        auth.sessionUserDefaultsKey = sessionUserDefaultsKey
        auth.requestedScopes =  requestedScopes
        player.diskCache = SPTDiskCache(capacity: 1024 * 1024 * 64)
    }
    
    var auth: SPTAuth!
    var player: SPTAudioStreamingController!
    
    weak var authViewController: SFSafariViewController?
    
    private var operation: (()->Void)? = nil
    var user: SPTUser?
    
    var accessToken: String? {
        return SPTAuth.defaultInstance().session?.accessToken
    }
    
    //MARK: - PLayer
    
    func playTrack() {
        
    }
    
    //MARK: - Track list
    
    func getPlaylistSnapshot(playlist: SPTPartialPlaylist, completion: @escaping PlaylistSnapshotResponse) {
        guard let accessToken = accessToken else {return}
        var block: ((Bool)->Void)!
        
        block = { (retryOnError: Bool) in
            
            SPTPlaylistSnapshot.playlist(withURI: playlist.uri, accessToken: accessToken, callback: {(error, data) in
                SpotifyManager.errorHandler(error, retryOnError: retryOnError, data: data as? SPTPlaylistSnapshot, operation: block, completion: { (error, data) in
                    guard let snapshot = data else {
                        if error != nil {
                            print(error!)
                        }
                        completion(error, nil)
                        return
                    }
                    let spSnapshot = SpotifyPlaylistSnapshot(snapshot: snapshot, partialPlaylist: playlist)
                    completion(nil, spSnapshot)
                })
            })
        }
        block(true)
    }
    
    func searchTrack(_ searchTrack: String, completion: @escaping TrackListPageResponse) {
        guard let accessToken = accessToken else {return}
        var block: ((Bool)->Void)!
        
        block = { (retryOnError: Bool) in
            SPTSearch.perform(withQuery: searchTrack, queryType: .queryTypeTrack, accessToken: accessToken, callback: {(error, data) in
                SpotifyManager.errorHandler(error, retryOnError: retryOnError, data: data as? SPTListPage, operation: block, completion: {(error, data) in
                    guard let data = data  else {return}
                    completion(error, SpotifyListPage(listPage: data))
                })
            })
        }
        block(true)
    }
    
    // MARK: - Playlist list
    
    func getCurrentUserPlaylists(completion: @escaping PlaylistListPageResponse) {
        if let user = user {
            getPlaylistListForUser(name: user.canonicalUserName, completion: completion)
        } else {
            getCurrentUser(completion: {[weak self] (error, user) in
                guard let sself = self, let user = user else {
                    completion(error, nil)
                    return
                }
                sself.getPlaylistListForUser(name: user.canonicalUserName, completion: completion)
            })
        }
    }
    
    func getPlaylistListForUser(name: String, completion: @escaping PlaylistListPageResponse) {
        guard let accessToken = accessToken else {return}
        var block: ((Bool)->Void)!
        
        block = {(retryOnError: Bool) in
            SPTPlaylistList.playlists(forUser: name, withAccessToken: accessToken, callback: {[weak self] (error, data) in
                guard let sself = self else {return}
                SpotifyManager.errorHandler(error, retryOnError: retryOnError, data: data as? SPTListPage, operation: block, completion: {[weak sself] (error, data) in
                    guard let ssself = sself else{return}
                    ssself.getPlaylistListCompletion(error: error, data: data, completion: completion)
                })
            })
        }
        block(true)
    }
    
    //MARK: - user request
    
    func getCurrentUser( completion: @escaping ((_ error: Error?, _ user: SPTUser?)->()) ) {
        guard let accessToken = accessToken else {return}
        var block: ((Bool)->Void)!
    
        block = {(retryOnError: Bool) in
            SPTUser.requestCurrentUser(withAccessToken: accessToken) {(error, user) in
                SpotifyManager.errorHandler(error, retryOnError: retryOnError, data: user as? SPTUser, operation: block, completion: completion)
            }
        }
        block(true)
    }
    
    /**
    Determine is need update session, and updated session
    */
    func updateSessionIfNeed(_ sender: UIViewController) {
        let operation = {[weak self] (_ sender: UIViewController)  in
            if SPTAuth.defaultInstance().session == nil {
                self?.showAuthentificationWebPage(sender)
            }
            
            if let session = SPTAuth.defaultInstance().session, !session.isValid() {
//                self?.renewSession()  TODO uncommentts
                self?.showAuthentificationWebPage(sender)
            }
        }
        
        performOperation {
            operation(sender)
        }
    }
    
    
    func canHandleAuth(url: URL) -> Bool {
        if auth.canHandle(url) {
            authViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            authViewController = nil
            auth.handleAuthCallback(withTriggeredAuthURL: url, callback: {[weak self] (error, session) in
                if let accessToken = session?.accessToken {
                    APIBase.setAccessToken(accessToken)
                }
                self?.handleAuthCallback(error, session: session)
            })
            return true
        }
        return false
    }
    
    private func showAuthentificationWebPage(_ sender: UIViewController) {
        guard let authURL = SPTAuth.defaultInstance().spotifyWebAuthenticationURL() else {return}
        let authViewController = SFSafariViewController(url: authURL)
        self.authViewController = authViewController
        sender.present(authViewController, animated: true, completion: nil)
    }
    
    static func renewSession(completion: @escaping (_ success: Bool) -> Void) { // need token refresh service
        guard let sesion = SPTAuth.defaultInstance().session else {return}
        SPTAuth.defaultInstance().renewSession(sesion) { (error, session) in
            completion(error != nil)
        }
    }
    
    // MARK: - Completion handler
    
    private func getPlaylistListCompletion(error: Error?, data: SPTListPage?, completion: @escaping ((_ error: Error?, _ playlistManager: SpotifyListPage<SPTPlaylistList, SPTPartialPlaylist>?)->())) {
        guard error == nil else {
            completion(error, nil)
            return
        }
        guard let playListList = data as? SPTPlaylistList else {
            completion(error, nil)
            return
        }
        completion(nil, SpotifyListPage(listPage: playListList))
    }
    
    private func handleAuthCallback(_ error: Error?, session: SPTSession?) {
        if let auth = auth, session != nil {
            or_postNotification(AppNotification.AppNotificationSpotifySessionDidUpdate.rawValue)
        }
    }
    
    // MARK: Error handler
    
    static func errorHandler<T>(_ error: Error?, retryOnError: Bool, data: T?, operation: @escaping (_ flag: Bool)->(), completion: (_ error: Error?, _ data: T?) -> ()) {
        guard let error = error as NSError? else {
            completion(nil, data)
            return
        }
        
        if retryOnError && error.code == NSURLErrorUserCancelledAuthentication {
            SpotifyManager.renewSession(completion: { (success) in
                operation(false)
            })
        } else {
            completion(error, data)
        }
    }
    
    //MARK: - Helpers methods
    
    private func performOperation(_ operation: () -> ()) {
        operation()
    }
}
