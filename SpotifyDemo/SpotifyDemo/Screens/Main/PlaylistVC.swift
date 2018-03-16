//
//  TrackListVC.swift
//  Spotify Demo
//
//  Created by Alexey Vedushev on 06/02/2018.
//  Copyright © 2018 Alexey Vedushev. All rights reserved.
//

import UIKit
import Spartan
import UIScrollView_InfiniteScroll

class PlaylistVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var findTextField: UITextField!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    var playlistURL: URL!
    
    private var playlist: SpotifyPlaylist!
    private var trackList = [CDTrack]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupData()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        addRefreshControll()
        
        tableView.addInfiniteScroll {[weak self] (tableView) in
            guard let sself = self else {return}
            sself.getNextPage(completion: {[weak self] in
                self?.tableView.finishInfiniteScroll()
            })
        }
    }
    
    private func setupData() {
        SpotifyManager.share.getPlaylistSnapshot(playlistURL: playlistURL) {[weak self] (error, snapshot) in
            guard let sself = self, let snapshot = snapshot else {
                self?.navigationController?.popViewController(animated: true)
                return
            }
            sself.playlist = snapshot
            sself.getNextPage()
        }
    }
    
    //MARK:- Refresh controll
    
    private func addRefreshControll() {
        let refreshControll = UIRefreshControl()
        refreshControll.addTarget(self, action: #selector(refreshList(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControll
        
    }
    
    @objc func refreshList(_ sender: UIRefreshControl?) {
        SpotifyManager.share.getPlaylistSnapshot(playlistURL: playlistURL) {[weak self] (error, snapshot) in
            guard let sself = self, let snapshot = snapshot else {return}
            sself.playlist = snapshot
            sself.getNextPage(completion: {
                sender?.endRefreshing()
            })
        }
    }
    
    //MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TrackTVCell.self)) as! TrackTVCell
        let track = trackList[indexPath.row]
        let durationStr = convertDurationMSToString(duration: Double(track.feature?.duration ?? 0))
        let cellData = TrackTVCell.Data(position: indexPath.row + 1, name: track.name!, artistName: track.artistName!, durationStr: durationStr, bpm: track.feature?.bpm ?? -1)
        cell.setup(data: cellData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        var rotation = CATransform3D()
        rotation = CATransform3DMakeRotation(CGFloat((90 * Double.pi) / 180), 0, 0.7, 0.4)
        rotation.m34 = 1 / -600
        
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 10, height: 10)
        cell.alpha = 0
        cell.layer.transform = rotation
        cell.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
        
        UIView.beginAnimations("rotation", context: nil)
        UIView.setAnimationDuration(0.4)
        cell.layer.transform = CATransform3DIdentity
        cell.alpha = 1
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        UIView.commitAnimations()
    }
    
    //MARK: - Helper methods
    
    private func getNextPage(completion: (()->Void)? = nil) {
        playlist.getNextPageIfAvailable {[weak self] (trackList) in
            guard let sself = self else {return}
            
            if !sself.isTrakcListEqually(firstTrackList: trackList, secondTrackList: sself.trackList) {
                sself.trackList = trackList
                sself.tableView.reloadData()
            }
            completion?()
        }
    }
    
    private func isTrakcListEqually(firstTrackList: [CDTrack], secondTrackList: [CDTrack]) -> Bool {
        if firstTrackList.count != secondTrackList.count {
            return false
        }
        
        for index in 0..<firstTrackList.count {
            guard firstTrackList[index].uid == secondTrackList[index].uid else {return false}
        }
        return true
    }
}


