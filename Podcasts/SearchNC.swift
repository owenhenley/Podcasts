//
//  SearchNC.swift
//  Podcasts
//
//  Created by Owen Henley on 12/15/18.
//  Copyright © 2018 Owen Henley. All rights reserved.
//

import UIKit
import Alamofire

class SearchNC: UITableViewController, UISearchBarDelegate {
    
    // MARK: - Properties
    
    let searchController = UISearchController(searchResultsController: nil)
    var podcasts = [Podcast]()
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    
    // MARK: - SetupFunctions
    
    fileprivate func setupViews() {
        setupSearchBar()
        setupTableView()
    }
    
    fileprivate func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    fileprivate func setupTableView() {
        // Register cell to tableView.
        // tableView.register(UITableViewCell.self, forCellReuseIdentifier: TableCells.podcastSearchCell)
        let nib = UINib(nibName: "PodcastCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: TableCells.podcastSearchCell)
    }
    
    
    // MARK: - UISearchBar Methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        APIService.shared.fetchPodcasts(searchText: searchText) { (podcasts) in
            self.podcasts = podcasts
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: - UITableView DataSource
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.podcastSearchCell, for: indexPath) as! PodcastCell
        let podcast = self.podcasts[indexPath.row]
        
        cell.podcast = podcast
        cell.selectionStyle = .none
        
        return cell
    }
    
}
