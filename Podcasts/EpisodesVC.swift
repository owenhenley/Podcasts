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
    
    var podcast: Podcast? {
        didSet {
            navigationItem.title = podcast?.trackName
            fetchEpisodes()
        }
    }
    fileprivate var episodes = [Episode]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
        // MARK: - Setup Methods
    
    func setupTableView() {
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: TableCells.podcastEpisodeCell)
        tableView.tableFooterView = UIView()
    }
    
        // MARK: - Methods
    
    fileprivate func fetchEpisodes() {
        guard let feedURL = podcast?.feedUrl else { return }
        let secureFeedURL = feedURL.contains("https") ? feedURL : feedURL.replacingOccurrences(of: "http", with: "https")
        guard let url = URL(string: secureFeedURL) else { return }
        
        let feedParser = FeedParser(URL: url)
        feedParser.parseAsync { (result) in
            print("Success:", result.isSuccess)

            switch result {
            case let .rss(feed): // Really Simple Syndication Feed Model
                self.appendFeeds(feed)
                break
            case let .failure(error):
                print("❌ ERROR in \(#file), \(#function), \(error),\(error.localizedDescription) ❌")
                break
            default:
                print("Found a feed...")
            }
        }
    }
    
    fileprivate func appendFeeds(_ feed: RSSFeed) {
        var parsedEpisodes = [Episode]()
        feed.items?.forEach { (feedItem) in
            let parsedEpisode = Episode(feedItem: feedItem)
            parsedEpisodes.append(parsedEpisode)
        }
        self.episodes = parsedEpisodes
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source
    
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
}
