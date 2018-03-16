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
    
    var spTrackListPage: SpotifyListPage<SPTListPage, SPTPartialTrack>?
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
//        cell.setup(name: (dataList[indexPath.row].name)!, imagePath: dataList[indexPath.row].album.images.first?.url)
        return cell
    }
    
    //MARK: Data
    
    private func search(_ text: String) {
        SpotifyManager.share.searchTrack(text) {[weak self] (eror, spListPage) in
            if let ids = (spListPage?.itemList.map{$0.identifier!}) {
                
            }
            
        }
    }
    
    private func getNextPage() {
        
    }
    
    private func getAccessToken() -> String? {
        return SPTAuth.defaultInstance().session.accessToken
    }
}
