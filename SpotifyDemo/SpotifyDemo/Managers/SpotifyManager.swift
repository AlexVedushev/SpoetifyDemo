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
    
    var auth: SPTAuth!
    var player: SPTAudioStreamingController!
    
    weak var authViewController: SFSafariViewController?
    private weak var parentController: UIViewController?
    private var user: SPTUser?
    private var playlistListPage: SPTPlaylistList?
    
    private var operation: (()->Void)? = nil
    
    var accessToken: String? {
        return SPTAuth.defaultInstance().session.accessToken
    }
    
    // MARK: - Playlist
    
    func getCurrentUserPlaylists(_ sender: UIViewController, isFirstRun: Bool = false, completion: @escaping ((_ error: Error?, _ playlistList: [SPTPartialPlaylist])->())) {
        if let user = user {
            getPlaylistListForUser(sender, name: user.canonicalUserName, completion: completion)
        } else {
            getCurrentUser(sender, completion: {[weak self] (error, user) in
                guard let sself = self, let user = user else {
                    completion(error, [])
                    return
                }
                sself.getPlaylistListForUser(sender, name: user.canonicalUserName, completion: completion)
            })
        }
    }
    
    func getPlaylistListForUser(_ sender: UIViewController, name: String, isFirstRun: Bool = false, completion: @escaping ((_ error: Error?, _ playlistList: [SPTPartialPlaylist])->())) {
        parentController = sender
        
        SPTPlaylistList.playlists(forUser: name, withAccessToken: accessToken!, callback: {[weak self] (error, data) in
            guard let sself = self else {return}
            sself.getPlaylistListCompletion(error: error, data: data, completion: completion)
        })
    }
    
    func getNextPagePlaylistList(completion: @escaping ((_ error: Error?, _ playlistList: [SPTPartialPlaylist])->())) {
        guard let playlistListPage = playlistListPage else {
            completion(nil, [])
            return
        }
        playlistListPage.requestNextPage(withAccessToken: accessToken!) {[weak self] (error, data) in
            guard let sself = self else {return}
            sself.getPlaylistListCompletion(error: error, data: data, completion: completion)
        }
    }
    
    //MARK: - user request
    
    func getCurrentUser(_ sender: UIViewController, completion: @escaping ((_ error: Error?, _ user: SPTUser?)->())) {
        SPTUser.requestCurrentUser(withAccessToken: accessToken!) {[weak self] (error, user) in
            guard let sself = self else {return}
            guard error == nil else {
                sself.errorHandler(error!)
                completion(error, nil)
                return
            }
            self?.user = user as? SPTUser
            completion(error, user as? SPTUser)
        }
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
    
    func renewSession(completion: @escaping () -> Void) { // need token refresh service
        guard let sesion = SPTAuth.defaultInstance().session else {return}
        SPTAuth.defaultInstance().renewSession(sesion) { (error, session) in
            print("erorr = \(error)")
            print("session = \(session)")
            completion()
        }
    }
    
    // MARK: - Completion handler
    
    private func getPlaylistListCompletion(error: Error?, data: Any?, isFirstRun: Bool = false, completion: @escaping ((_ error: Error?, _ playlistList: [SPTPartialPlaylist])->())) {
        guard error == nil else {
            completion(error, [])
            errorHandler(error!)
            return
        }
        guard let playListList = data as? SPTPlaylistList, let playlistItems = playListList.items as? [SPTPartialPlaylist] else {
            completion(error, [])
            return
        }
        playlistListPage = playListList
        completion(nil, playlistItems)
        // SPTPlaylistSnapshot.playlist(withURI: playListList, accessToken: <#T##String!#>, callback: <#T##SPTRequestCallback!##SPTRequestCallback!##(Error?, Any?) -> Void#>)
    }
    
    private func handleAuthCallback(_ error: Error?, session: SPTSession?) {
        if let auth = auth, session != nil {
            player.login(withAccessToken: auth.session.accessToken)
        }
    }
    
    // MARK: Error handler
    
    private func errorHandler(_ error: Error?) {
        guard let error = error as NSError? else { return }
        print(error)
        
        if error.code == 401 {
            renewSession(completion: {
                
            })
            
        }
    }
    
    //MARK: - Helpers methods
    
    private func performOperation(_ operation: () -> ()) {
        operation()
    }
}
