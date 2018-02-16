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

class TrackListVC: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var findTextField: UITextField!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    var playlistId: String!
    var pagingObj: PagingObject<PlaylistTrack>?
    var audioFeatureList: [AudioFeaturesObject]?
    var user: PrivateUser?
    var trackList: [Track] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        downloadAlbumTrackList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        tableView.addInfiniteScroll {[weak self] (tableView) in
            guard let sself = self else {return}
            sself.getNextPage()
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    
    private func downloadAlbumTrackList() {
        guard  let albumId = playlistId else {return}
        
        Spartan.getMe(success: {[weak self] (user) in
            guard let sself = self else {return}
            sself.user = user
            sself.getFirstPageAndReloadTableIfAllowed()
        }) { (error) in
            print(error)
        }
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
        return trackList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TrackTVCell.self)) as! TrackTVCell
        if let featureList = audioFeatureList {
            let track = trackList[indexPath.row]
            
            let artitsName: String = {
                let artistNameList: [String] = track.album.artists.map{$0.name}
                return artistNameList.joined(separator: ", ")
            }()

            cell.setup(name: track.name, artistName: artitsName, previewURL: track.album.images.first?.url ?? "")
        }
        return cell
    }
    
    //MARK: - Helper methods
    
    private func find() {
        
    }
    
    private func getFirstPageAndReloadTableIfAllowed() {
        guard let user = user else{
            print("User is not defined")
            return
        }
        Spartan.getPlaylistTracks(userId: (user.id as! String), playlistId: playlistId, success: {[weak self] (pagObj) in
            guard let sself = self else {return}
            sself.pagingObj = pagObj
            sself.trackList = pagObj.items.map{$0.track!}
            
            Spartan.getAudioFeatures(trackIds: pagObj.items.map{($0.track.id as! String)}, success: {[weak sself] (featureList) in
                guard let ssself = sself else {return}
                ssself.audioFeatureList = featureList
                ssself.tableView.reloadData()
                }, failure: { (error) in
                    print(error)
            })
            }, failure: { (error) in
                print(error)
        })
    }
    
    private func getNextPage() {
        pagingObj?.getNext(success: {[weak self] (pagingObj) in
            guard let sself = self else{return}
            sself.pagingObj = pagingObj
            sself.trackList.append(contentsOf: pagingObj.items.map{$0.track!})
            
            Spartan.getAudioFeatures(trackIds: pagingObj.items.map{($0.track.id as! String)}, success: {[weak sself] (featureList) in
                guard let ssself = sself else {return}
                ssself.audioFeatureList = featureList
                ssself.tableView.reloadData()
                ssself.tableView.finishInfiniteScroll()
                
                }, failure: {[weak sself] (error) in
                    guard let ssself = sself else {return}
                    ssself.tableView.finishInfiniteScroll()
                    print(error)
            })
            }, failure: { (error) in
                print(error)
        })
    }
    
    
}


