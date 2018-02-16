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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshController()
        addInfiniteScroll()
        getFirstPage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        if paginationObject == nil {
            Spartan.getMyPlaylists(success: {[weak self] (pagingObject) in
                guard let sself = self else {return}
                sself.paginationObject = pagingObject
                sender?.endRefreshing()
            }) { (error) in
                sender?.endRefreshing()
                Spartan.authorizationToken = SPTAuth.defaultInstance().session.accessToken
                print(error)
            }
        } else {
           getFirstPage()
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return (paginationObject == nil) ? 0 : 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paginationObject?.items.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PlayListTVCell.self), for: indexPath) as! PlayListTVCell
        
        if let items = paginationObject?.items {
            cell.setupData(listName: items[indexPath.row].name, trackCount: items[indexPath.row].tracksObject.total, imageURi: items[indexPath.row].images.first?.url ?? "")
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let itemList = paginationObject?.items else {return}
        let vc = VCEnum.tracklist.vc as! TrackListVC
        vc.playlistId = (itemList[indexPath.row].id as! String)
        show(vc, sender: self)
    }

    
    // MARK: - Helpers metods
    
    private func getFirstPage() {
        Spartan.getMyPlaylists(success: {[weak self] (pagingObject) in
            guard let sself = self else {return}
            sself.paginationObject = pagingObject
            sself.reloadTableAndStopRefresh()
        }) {[weak self] (error) in
            guard let sself = self else {return}
            Spartan.authorizationToken = SPTAuth.defaultInstance().session.accessToken
            sself.reloadTableAndStopRefresh()
            print(error)
        }
    }
    
    private func reloadTableAndStopRefresh() {
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
}
