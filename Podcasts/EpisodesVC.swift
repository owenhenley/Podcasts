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
    
    // MARK: - Properties
    private var episodes = [Episode]()
    private let favoritedPodcastKey = "favoritedPodcastKey"
    
    // MARK: Computed Properties
    var podcast: Podcast? {
        didSet {
            navigationItem.title = podcast?.trackName
            fetchEpisodes()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBarButtons()
    }
    
    // MARK: - Setup Methods
    private func setupNavigationBarButtons() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Favorite", style: .plain, target: self, action: #selector(handleSaveFavorite)),
            UIBarButtonItem(title: "Fetch", style: .plain, target: self, action: #selector(handleFetchSavedPodcasts))
        ]
    }

    private func setupTableView() {
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: TableCells.podcastEpisodeCell)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .onDrag
    }
    
    // MARK: - Methods
    @objc private func handleSaveFavorite() {
        print("Saving info into UserDefaults")

        guard let podcast = self.podcast else { return }

        // 1. Transform Podcast into Data
        // Discontinued in iOS 12
        let data = NSKeyedArchiver.archivedData(withRootObject: podcast)

        UserDefaults.standard.set(data, forKey: favoritedPodcastKey)
    }

    @objc private func handleFetchSavedPodcasts() {
        print("Fetching saved Podcasts from UserDefaults")
        let value = UserDefaults.standard.value(forKey: favoritedPodcastKey) as? String
        print(value ?? "")

        // How to retrieve our Podcast object from UserDefaults
        guard let data = UserDefaults.standard.data(forKey: favoritedPodcastKey) else { return }
        // Discontinued in iOS 12
        let podcast = NSKeyedUnarchiver.unarchiveObject(with: data) as? Podcast
        print(podcast?.trackName ?? "", podcast?.artistName ?? "")
    }

    private func fetchEpisodes() {
        guard let feedURL = podcast?.feedUrl else { return }
        APIService.shared.fetchEpisodes(feedURL: feedURL) { (episodes) in
            self.episodes = episodes
            self.tableView.reloadOnMainThread()
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = self.episodes[indexPath.row]
        let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
        mainTabBarController?.openAudioPlayer(episode: episode, playlistEpisodes: episodes)
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
