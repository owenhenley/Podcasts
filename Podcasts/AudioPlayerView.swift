//
//  AudioPlayerView.swift
//  Podcasts
//
//  Created by Owen Henley on 12/31/18.
//  Copyright © 2018 Owen Henley. All rights reserved.
//

import UIKit
import AVKit

class AudioPlayerView: UIView {

    @IBOutlet weak var backButton: UIButton! {
        didSet {
            backButton.contentHorizontalAlignment = .left
        }
    }
    @IBOutlet weak var episodeIconImageView: UIImageView!
    @IBOutlet weak var episodeTitleLabel: UILabel! {
        didSet {
            episodeTitleLabel.numberOfLines = 2
        }
    }
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton! {
        didSet {
            playPauseButton.setImage(PlayerIcons.Pause, for: .normal)
            playPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
    }
    
    
    let player: AVPlayer = { // ????????
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    var episode: Episode! {
        didSet {
            playEpisode()
            episodeTitleLabel.text = episode.title
            authorLabel.text = episode.author
            guard let imageURL = URL(string: episode.iconURL?.convertedToHTTPS() ?? "") else { return }
            episodeIconImageView.sd_setImage(with: imageURL)
        }
    }
    
    @objc fileprivate func handlePlayPause() {
        print("Playing Pausing")
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButton.setImage(PlayerIcons.Pause, for: .normal)
        } else {
            player.pause()
            playPauseButton.setImage(PlayerIcons.Play, for: .normal)
        }
    }
    
    
    @IBAction func backTapped(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    @IBAction func playPauseTapped(_ sender: UIButton) {
        
    }
    
    fileprivate func playEpisode() {
        print("Trying to play episode: ", episode.title, episode.streamURL)
        guard let streamURL = URL(string: episode.streamURL) else { return }
        let playerItem = AVPlayerItem(url: streamURL)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
}
