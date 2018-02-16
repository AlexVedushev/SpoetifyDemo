//
//  ViewController.swift
//  Spotify Demo
//
//  Created by Alexey Vedushev on 06/02/2018.
//  Copyright © 2018 Alexey Vedushev. All rights reserved.
//

import UIKit
import Spartan

class OldPlayListVC: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var findTextField: UITextField!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
//    var spUser: SPTUser!
//    var trackList: [SPTPartialTrack] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupData()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func setupData() {
//        Spartan.getTracks(albumId: <#T##String#>, success: <#T##((PagingObject<SimplifiedTrack>) -> Void)##((PagingObject<SimplifiedTrack>) -> Void)##(PagingObject<SimplifiedTrack>) -> Void#>, failure: <#T##((SpartanError) -> Void)?##((SpartanError) -> Void)?##(SpartanError) -> Void#>)
//        requestUser {[weak self] (user) in
//            guard let sself = self else {return}
//
//            guard let user = user else {
//                print("Error: get current user failed")
//                return
//            }
//            sself.spUser = user
//
//            sself.getUserPlaylist(completion: {[weak self] (playList) in
//                guard let ssself = self else {return}
//                ssself.trackList = playList ?? []
//                ssself.tableView.reloadData()
//            })
//        }
    }
    
    @IBAction func findDidPressed(_ sender: Any) {
        find()
    }
    
    //MARK: - UITextFieldDelegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        find()
        textField.resignFirstResponder()
    }
    
    //MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TrackTVCell.self)) as! TrackTVCell
        
        return cell
    }
    
    //MARK: - Helper methods
    
    private func find() {
        getTrackBy(name: findTextField.text ?? "")
    }
    
    private func getTrackBy(name: String) {
        guard let accessToken = getAccessToken() else {return}
        
        SPTSearch.perform(withQuery: name, queryType: SPTSearchQueryType.queryTypeTrack, accessToken: accessToken, callback: {[weak self] (error, list) in
            guard let sself = self, let listPage = list as? SPTListPage else {return}
//            sself.trackList = (listPage.items as? [SPTPartialTrack]) ?? []
        })
    }
    
    private func getUserPlaylist(completion: @escaping ([SPTPartialTrack]?)->()) {
        guard let accessToken = SPTAuth.defaultInstance().session.accessToken else { return }
        
        SPTPlaylistList.playlists(forUser: "username", withAccessToken: accessToken) { (error, list) in
            guard error == nil else {
                print(error!)
                completion(nil)
                return
            }
            
            guard let playListList = list as? SPTPlaylistList, let partialPlayListList = playListList as? [SPTPartialPlaylist] else {
                completion(nil)
                return
            }
//            do {
//                guard let playListList = list as? SPTPlaylistList else {
//                    completion(nil)
//                    return
//                }
//                let playlist: SPTPlaylistList = try SPTPlaylistList(from: data, with: response)
//                
//                guard let playList = playlist.items as? [SPTPartialTrack] else {
//                    completion(nil)
//                    return
//                }
//                completion(playList)
//            } catch {
//                print(error)
//                completion(nil)
//            }
        }
    }
    
    private func requestUser(completion: ((SPTUser?)->())? = nil) {
        guard let accessToken = SPTAuth.defaultInstance().session.accessToken else { return }
        print("ACCESS TOKEN: \(accessToken)")
        
        SPTUser.requestCurrentUser(withAccessToken: accessToken) {[weak self] (error, data) in
            guard let user = data as? SPTUser else {
                completion?(nil)
                return
            }
            self?.findButton.isEnabled = true
            completion?(user)
        }
    }
    
    private func getUserPlayListRequest() -> URLRequest? {
        guard let accessToken = getAccessToken() else {return nil}
        do {
            let url = try SPTPlaylistList.createRequestForGettingPlaylists(forUser: "user name", withAccessToken: accessToken)
            return url
        }catch {
            print(error)
        }
        return nil
    }
    
    private func getMuscByNameRequest(_ name: String) -> URLRequest? {
        guard let accessToken = getAccessToken() else {return nil}
        do {
            let query = try SPTSearch.createRequestForSearch(withQuery: name, queryType: SPTSearchQueryType.queryTypeTrack, accessToken: accessToken)
            return query
        }catch {
            print(error)
        }
        return nil
    }
    
    private func getAccessToken() -> String? {
        guard let session = SPTAuth.defaultInstance().session,
            let accessToken = session.accessToken else {
                return nil
        }
        return accessToken
    }
    
}

