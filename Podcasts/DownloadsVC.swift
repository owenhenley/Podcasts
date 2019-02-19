//
//  DownloadsVC.swift
//  Podcasts
//
//  Created by Owen Henley on 2/18/19.
//  Copyright © 2019 Owen Henley. All rights reserved.
//

import UIKit

class DownloadsVC: UITableViewController {

    // MARK: - Properties
    private let cellId = "downloadsCellId"
    private var episodes = UserDefaults.standard.downloadedEpisodes()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupObservers()
    }

    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleDownloadProgress), name: .downloadProgress, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDownloadComplete), name: .downloadComplete, object: nil)
    }

    @objc func handleDownloadComplete(notification: Notification) {
        guard let episodeDownloadComplete = notification.object as? APIService.EpisodeDownloadCompleteTuple else { return }
        guard let index = self.episodes.firstIndex(where: { $0.title == episodeDownloadComplete.episodeTitle }) else { return }
        self.episodes[index].fileURL = episodeDownloadComplete.fileURL
    }

    @objc func handleDownloadProgress(notification: Notification) {
        guard let userInfo = notification.userInfo as? [String : Any] else { return }
        guard let progress = userInfo["downloadProgress"] as? Double else { return }
        guard let title = userInfo["title"] as? String else { return }
        print(title, progress)

        guard let index = self.episodes.firstIndex(where: { $0.title == title }) else { return }
        guard let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? EpisodeCell else { return }
        cell.progressLabel.isHidden = false
        cell.progressLabel.text = "\(Int(progress * 100))%"

        if progress == 1 {
            cell.progressLabel.isHidden = true
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        episodes = UserDefaults.standard.downloadedEpisodes()
        tableView.reloadData()
    }

    // MARK: - Setup
    private func setupTableView() {
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
    }

    // MARK: - UITableView
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = self.episodes[indexPath.row]
        if episode.fileURL != nil {
            UIApplication.mainTabBarController()?.openAudioPlayer(episode: episode, playlistEpisodes: self.episodes)
        } else {
            let alert = UIAlertController(title: "Oops!",
                                          message: "Sorry, The podcast's downloaded file could not be not found 🤔, play using the stream instead?",
                                          preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
                UIApplication.mainTabBarController()?.openAudioPlayer(episode: episode, playlistEpisodes: self.episodes)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

            present(alert, animated: true, completion: nil)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? EpisodeCell else {
            return UITableViewCell()
        }

        cell.episode = self.episodes[indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let episode = self.episodes[indexPath.row]
        episodes.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        UserDefaults.standard.deleteEpisode(episode: episode)
    }
}
