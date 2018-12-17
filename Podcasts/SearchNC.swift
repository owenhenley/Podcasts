//
//  SearchNC.swift
//  Podcasts
//
//  Created by Owen Henley on 12/15/18.
//  Copyright © 2018 Owen Henley. All rights reserved.
//

import UIKit

class SearchNC: UITableViewController, UISearchBarDelegate {
    
        // MARK: - Properties
    
    let searchController = UISearchController(searchResultsController: nil)
    let mockPodcasts = [
        Podcast(name: "podcast1", artist: "artist1"),
        Podcast(name: "podcast2", artist: "artist2"),
        Podcast(name: "podcast3", artist: "artist3"),
        Podcast(name: "podcast4", artist: "artist4")
    ]
    
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: TableCells.podcastSearchCell)
    }
    
    
        // MARK: - UISearchBar Methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // TODO: -  Impliment Alamofire
    }
    
    
        // MARK: - UITableView DataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mockPodcasts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.podcastSearchCell, for: indexPath)
        let podcast = self.mockPodcasts[indexPath.row]
        
        cell.textLabel?.text = "\(podcast.name)\n\(podcast.artist)"
        cell.textLabel?.numberOfLines = 0
        cell.imageView?.image = Icon.DefaultSmall
        cell.selectionStyle = .none
        
        return cell
    }
    
}
