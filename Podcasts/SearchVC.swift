//
//  SearchNC.swift
//  Podcasts
//
//  Created by Owen Henley on 12/15/18.
//  Copyright © 2018 Owen Henley. All rights reserved.
//

import UIKit
import Alamofire

class SearchVC: UITableViewController, UISearchBarDelegate {
    
    // MARK: - Properties
    
    let searchController = UISearchController(searchResultsController: nil)
    var podcasts = [Podcast]()
    var timer: Timer?
    var searchingActivityIndictor = Bundle.main.loadNibNamed("PodcastsSearchingView", owner: self, options: nil)?.first as? UIView
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        searchBar(searchController.searchBar, textDidChange: "seanallen")
    }
    
    
    // MARK: - SetupFunctions
    
    fileprivate func setupViews() {
        setupSearchBar()
        setupTableView()
    }
    
    fileprivate func setupSearchBar() {
        self.definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    fileprivate func setupTableView() {
        tableView.tableFooterView = UIView()
        let nib = UINib(nibName: "PodcastCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: TableCells.podcastSearchCell)
        tableView.keyboardDismissMode = .onDrag
    }
    
        // MARK: - Methods
    fileprivate func addActivityIndicator() -> UIView {
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.color = .blue
        activityIndicator.startAnimating()
        let searchingLabel = UILabel()
        searchingLabel.text = "Searching..."
        
        let views: [UIView] = [activityIndicator, searchingLabel]
        let activityView = UIStackView(arrangedSubviews: views)
        activityView.axis = .vertical
        // activityView.spacing = 8
        activityView.alignment = .center
        view.addSubview(activityView)
        return activityView
    }
    
    
    
        // MARK: - UISearchBar Methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        podcasts = []
        tableView.reloadData()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false, block: { (timer) in
            APIService.shared.fetchPodcasts(searchText: searchText) { (podcasts) in
                self.podcasts = podcasts
                self.tableView.reloadData()
            }
        })
    }
    
    
    
        // MARK: - UITableView DataSource
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episodesVC = EpisodesVC()
        let podcast = self.podcasts[indexPath.row]
        episodesVC.podcast = podcast
        navigationController?.pushViewController(episodesVC, animated: true)
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        resignFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "What are you searching for?"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return searchingActivityIndictor
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return podcasts.isEmpty && searchController.searchBar.text?.isEmpty == true ? 250 : 0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return podcasts.isEmpty && searchController.searchBar.text?.isEmpty == false ? 250 : 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.podcastSearchCell, for: indexPath) as? PodcastCell else { return UITableViewCell() }
        let podcast = self.podcasts[indexPath.row]
        cell.podcast = podcast
        return cell
    }
    
}
