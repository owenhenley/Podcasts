//
//  EpisodesVC.swift
//  Podcasts
//
//  Created by Owen Henley on 12/30/18.
//  Copyright © 2018 Owen Henley. All rights reserved.
//

import UIKit
import FeedKit


class EpisodesVC: UITableViewController {
    
    /// An array of Episodes to be displayed on the UITableView
    fileprivate var episodes = [Episode]()
    var podcast: Podcast? {
        didSet {
            navigationItem.title = podcast?.trackName
            fetchEpisodes()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
        // MARK: - Setup Methods
    
    func setupTableView() {
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: TableCells.podcastEpisodeCell)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .onDrag
    }
    
        // MARK: - Methods
    
    fileprivate func fetchEpisodes() {
        guard let feedURL = podcast?.feedUrl else { return }
        APIService.shared.fetchEpisodes(feedURL: feedURL) { (episodes) in
            self.episodes = episodes
            self.tableView.reloadOnMainThread()
        }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = self.episodes[indexPath.row]
        print("starting playback for ", episode.title)
        let audioPlayerView = Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as! AudioPlayerView
        audioPlayerView.episode = episode
        audioPlayerView.frame = self.view.frame
        let window = UIApplication.shared.keyWindow
        window?.addSubview(audioPlayerView)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.podcastEpisodeCell, for: indexPath) as? EpisodeCell else { return UITableViewCell() }
        let episode = episodes[indexPath.row]
        cell.episode = episode
        tableView.tableFooterView = UIView()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.color = .blue
        activityIndicator.startAnimating()
        return activityIndicator
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return episodes.isEmpty ? (view.frame.height / 2) : 0
    }
}
