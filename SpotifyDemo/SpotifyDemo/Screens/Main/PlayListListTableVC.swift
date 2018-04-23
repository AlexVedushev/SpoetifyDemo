//
//  PlayListListTableVC.swift
//  Spotify Demo
//
//  Created by Alexey Vedushev on 13/02/2018.
//  Copyright © 2018 Alexey Vedushev. All rights reserved.
//

import UIKit
import ORCommonCode_Swift

class PlayListListTableVC: UITableViewController {
    
    var playlistListObj: SpotifyListPage<SPTPlaylistList, SPTPartialPlaylist>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SpotifyManager.share.updateSessionIfNeed(self)
        
        if let accessToken = SPTAuth.defaultInstance().session?.accessToken {
            print("ACCESS TOKEN = \(accessToken)")
            APIBase.setAccessToken(accessToken)
        }
        setupRefreshController()
        addInfiniteScroll()
        getFirstPage()
        or_addObserver(self, selector: #selector(sessionDidUpdate), name: AppNotification.AppNotificationSpotifySessionDidUpdate.rawValue)
    }

    deinit {
        or_removeObserver(self, name: AppNotification.AppNotificationSpotifySessionDidUpdate.rawValue)
    }
    
    //MARK: - Setup
    
    private func setupRefreshController() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshList(_:)), for: .valueChanged)
    }
    
    private func addInfiniteScroll() {
        tableView.addInfiniteScroll {[weak self] (tableView) in
            guard let sself = self, let playlistListObj = sself.playlistListObj else {return}
            playlistListObj.getNextPage(completion: { (error, playlistList) in
                guard let sself = self else {return}
                
                if let error = error {
                    sself.showErrorAlert(message: error.localizedDescription)
                }
            })
        }
    }

    // MARK: - Action
    
    @objc func refreshList(_ sender: UIRefreshControl?) {
        getFirstPage {
            sender?.endRefreshing()
        }
    }
    
    //MARK: - Notification
    
    @objc func sessionDidUpdate(_ notification: NSNotification) {
        getFirstPage()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlistListObj?.itemList.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PlayListTVCell.self), for: indexPath) as! PlayListTVCell
        let playlist = playlistListObj!.itemList[indexPath.row]
        cell.setupData(listName: playlist.name, trackCount: Int(playlist.trackCount), imageURi: playlist.smallestImage.imageURL)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playlist = playlistListObj!.itemList[indexPath.row]
        
        let vc = VCEnum.tracklist.vc as! PlaylistVC
        vc.partialPlaylist = playlist
        show(vc, sender: self)
    }

    
    // MARK: - Helpers metods
    
    private func getFirstPage(completion: (()->Void)? = nil) {
        SpotifyManager.share.getCurrentUserPlaylists {[weak self] (error, playlistListObj) in
            completion?()
            guard let sself = self else{return}
            if let error = error {
                sself.showErrorAlert(message: error.localizedDescription)
                return
            }
            
            if let playlistListObj = playlistListObj {
                sself.playlistListObj = playlistListObj
                sself.tableView.reloadData()
            }
        }
    }
    
    private func reloadTableAndStopRefresh() {
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
    }
}
