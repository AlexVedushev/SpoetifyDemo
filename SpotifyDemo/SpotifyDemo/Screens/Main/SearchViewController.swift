//
//  SearchViewController.swift
//  SpotifyDemo
//
//  Created by Alexey Vedushev on 15/02/2018.
//  Copyright © 2018 Alexey Vedushev. All rights reserved.
//

import UIKit
import ORCommonCode_Swift
import ORCommonUI_Swift
import Spartan

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

    enum SearchType {
        case track
        case artist
        
        var spartanSearchType: ItemSearchType {
            switch self {
            case .track:
                return .track
            case .artist:
                return .artist
            }
        }
        
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var searchType: SearchType = .track
    
    var pagingObject: PagingObject<Track>?
    var listPage: SPTListPage?
    var dataList: [Track] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Setup methods
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.keyboardDismissMode = .onDrag
        
        tableView.addInfiniteScroll {[weak self] (tableView) in
            guard let sself = self else {return}
            sself.getNextPage()
        }
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
    }
    
    //MARK: - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search(searchBar.text ?? "")
        searchSpotifySDK()
        
    }
    
    //MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = getCell(tableView, cellForRowAt: indexPath)
        return cell
    }
    
    // MARK: - Helpers
    
    
    //MARK: Table view
    
    private func getCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SearchTVCell.self)) as! SearchTVCell
        
        if let itemList = dataList as? [Track] {
            cell.setup(name: (itemList[indexPath.row].name)!, imagePath: itemList[indexPath.row].album.images.first?.url)
        }
        return cell
    }
    
    //MARK: Data
    
    private func search(_ text: String) {
        Spartan.search(query: searchBar.text ?? "", type: searchType.spartanSearchType, success: {[weak self] (pagObj: PagingObject<Track>) in
            guard let sself = self else {return}
            sself.pagingObject = pagObj
            sself.dataList = pagObj.items
            sself.tableView.reloadData()
        }) { (error) in
            if error.errorType == .unauthorized {
                Spartan.authorizationToken = SPTAuth.defaultInstance().session.accessToken
            }
            print(error)
        }
    }
    
    private func getNextPage() {
        guard let pagObj = pagingObject else {
            search(searchBar.text ?? "")
            return
        }
        pagObj.getNext(success: {[weak self] (pagObj) in
            guard let sself = self else {return}
            sself.tableView.finishInfiniteScroll()
            sself.pagingObject = pagObj
            sself.dataList.append(contentsOf: pagObj.items ?? [])
            sself.tableView.reloadData()
        }) {[weak self] (error) in
            guard let sself = self else {return}
            sself.tableView.finishInfiniteScroll()
            print(error)
        }
        guard let accessToken = getAccessToken() else {
            return
        }
        listPage?.requestNextPage(withAccessToken: accessToken, callback: { (error, response) in
            print(response)
        })
    }
    
    private func searchSpotifySDK() {
        guard let accessToken = getAccessToken() else {return}
        
        SPTSearch.perform(withQuery: searchBar.text ?? "", queryType: SPTSearchQueryType.queryTypeTrack, accessToken: accessToken) {[weak self] (error, data) in
            guard let sself = self, let listPage = data as? SPTListPage else {return}
            let trackList = (listPage.items as? [SPTPartialTrack]) ?? []
            sself.listPage = listPage
            print("listPage.items = \(listPage.items.count)")
        }
    }
    
    private func getAccessToken() -> String? {
        return SPTAuth.defaultInstance().session.accessToken
    }
}
