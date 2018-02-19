//
//  PlayListListTableVC.swift
//  Spotify Demo
//
//  Created by Alexey Vedushev on 13/02/2018.
//  Copyright © 2018 Alexey Vedushev. All rights reserved.
//

import UIKit
import Spartan

class PlayListListTableVC: UITableViewController {
    
    var paginationObject: PagingObject<SimplifiedPlaylist>?
    var playlistList: [SPTPartialPlaylist] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SpotifyManager.share.updateSessionIfNeed(self)
        setupRefreshController()
        addInfiniteScroll()
        getFirstPage()
    }
    
    //MARK: - Setup
    
    private func setupRefreshController() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshList(_:)), for: .valueChanged)
    }
    
    private func addInfiniteScroll() {
        tableView.addInfiniteScroll {[weak self] (tableView) in
            guard let sself = self else {return}
            sself.paginationObject?.getNext(success: { (pagObject) in
                guard let ssself = self else {return}
                ssself.paginationObject = pagObject
                ssself.tableView.reloadData()
            }, failure: { (error) in
                print(error)
            })
        }
    }

    // MARK: - Action
    
    @objc func refreshList(_ sender: UIRefreshControl?) {
        getFirstPage()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlistList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PlayListTVCell.self), for: indexPath) as! PlayListTVCell
        let playlist = playlistList[indexPath.row]
        cell.setupData(listName: playlist.name, trackCount: Int(playlist.trackCount), imageURi: playlist.smallestImage.imageURL)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playlist = playlistList[indexPath.row]
        let vc = VCEnum.tracklist.vc as! TrackListVC
        
        show(vc, sender: self)
    }

    
    // MARK: - Helpers metods
    
    private func getFirstPage() {
        SpotifyManager.share.getCurrentUserPlaylists(self) {[weak self] (error, playlist) in
            guard let sself = self, error == nil else {
                print(error!)
                return
            }
            sself.playlistList = playlist
            sself.reloadTableAndStopRefresh()
        }
    }
    
    private func reloadTableAndStopRefresh() {
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
}
