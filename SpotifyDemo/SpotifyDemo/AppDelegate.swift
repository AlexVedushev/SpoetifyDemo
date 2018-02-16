//
//  AppDelegate.swift
//  Spotify Demo
//
//  Created by Alexey Vedushev on 06/02/2018.
//  Copyright © 2018 Alexey Vedushev. All rights reserved.
//

import UIKit
import SafariServices
import Spartan

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SPTAudioStreamingDelegate, SFSafariViewControllerDelegate {

    var window: UIWindow?
    var auth: SPTAuth!
    var player: SPTAudioStreamingController!
    var authViewController: UIViewController!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        auth = SPTAuth.defaultInstance()
        player = SPTAudioStreamingController.sharedInstance()
        auth.clientID = "ca19f9334ea84e85a4194cc096dea9f1"
        auth.redirectURL = URL(string: "spotify-ios-demo-login://")
        
        auth.sessionUserDefaultsKey = "current session"
        auth.requestedScopes = [SPTAuthStreamingScope]
        player.delegate = self
        do {
            try player.start(withClientId: auth.clientID)
        } catch  {
            print("There was a problem starting the Spotify SDK \(error.localizedDescription)")
        }
        
        DispatchQueue.main.async {[weak self] in
            self?.stareAuthenticationFlow()
        }
        stareAuthenticationFlow()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if auth.canHandle(url) {
            authViewController.presentingViewController?.dismiss(animated: true, completion: nil)
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
    
    // MARK: - SPTAudioStreamingDelegate
    
    func audioStreamingDidReconnect(_ audioStreaming: SPTAudioStreamingController!) {
        
        print("ACCESS TOKEN: \(auth.session.accessToken)")
    }
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        player.playSpotifyURI("spotify:track:4zvQE9LuGzE2r1zcDiDoZy", startingWith: 0, startingWithPosition: 0) { (error) in
            if error != nil {
                print("Falied to play")
                return
            }
        }
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didReceiveError error: Error!) {
        print(error)
    }
    
    func audioStreamingDidEncounterTemporaryConnectionError(_ audioStreaming: SPTAudioStreamingController!) {
        print("audioStreamingDidEncounterTemporaryConnectionError")
    }
    
    func audioStreamingDidLogout(_ audioStreaming: SPTAudioStreamingController!) {
        print("audioStreamingDidLogout")
    }
    
    //MARK: - SFSafariViewControllerDelegate
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        guard let accessToken = auth.session.accessToken else {return}
        print("ACCESS TOKEN: \(accessToken)")
        Spartan.authorizationToken = accessToken
        APIBase.setAccessToken(accessToken)
    }
    
    //MARK: - Helper methods
    
    func stareAuthenticationFlow() {
        if let session = auth.session, session.isValid() {
            print("ACCESS TOKEN: \(session.accessToken)")
            APIBase.setAccessToken(auth.session.accessToken)
            Spartan.authorizationToken = auth.session.accessToken
            player.login(withAccessToken: auth.session.accessToken)
        } else {
            if let ssession = auth.session {
                auth.renewSession(ssession, callback: {[weak self] (error, newSession) in
                    guard error == nil else {
                        print(error!)
                        self?.showAuthentificationWebPage()
                        return
                    }
                    self?.auth.session = newSession
                })
            } else {
                showAuthentificationWebPage()
            }
        }
    }
    
    private func showAuthentificationWebPage() {
        guard let authURL = auth.spotifyWebAuthenticationURL() else {return}
        authViewController = SFSafariViewController(url: authURL)
        (authViewController as! SFSafariViewController).delegate = self
        window?.rootViewController?.present(authViewController, animated: true, completion: nil)
    }

}

