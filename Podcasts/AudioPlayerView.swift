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

        // MARK: - Outlets
    
    @IBOutlet weak var openedPlayerStackView: UIStackView!
    @IBOutlet weak var audioPlayerMiniView: UIView!
    
        // MARK: Mini Player
    
    @IBOutlet weak var miniEpisodeIconImageView: UIImageView!
    @IBOutlet weak var miniEpisodeTitle: UILabel!
    @IBOutlet weak var miniFastForwardButton: UIButton!
    
        // MARK: Full Player

    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var currentTimeSlider: UISlider!
    
        // MARK: Computed Outlets
    
    @IBOutlet weak var dismissButton: UIButton! {
        didSet {
            dismissButton.contentHorizontalAlignment = .center
        }
    }
    
    @IBOutlet weak var episodeIconImageView: UIImageView! {
        didSet {
            episodeIconImageView.layer.cornerRadius = 10
            episodeIconImageView.clipsToBounds = true
            episodeIconImageView.transform = self.shrunkenImageScale
        }
    }
    
    @IBOutlet weak var episodeTitleLabel: UILabel! {
        didSet {
            episodeTitleLabel.numberOfLines = 2
        }
    }
    
    @IBOutlet weak var playPauseButton: UIButton! {
        didSet {
            playPauseButton.setImage(PlayerIcons.Pause, for: .normal)
            playPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var miniPlayPauseButton: UIButton! {
        didSet {
            miniPlayPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
    }
    
    
    
        // MARK: - Properties
    
    fileprivate let shrunkenImageScale = CGAffineTransform(scaleX: 0.7, y: 0.7)
    
        // MARK: Computed Properties
    
    let player: AVPlayer = { // ????????
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    var episode: Episode! {
        didSet {
            playEpisode()
            episodeTitleLabel.text = episode.title
            miniEpisodeTitle.text = episode.title
            authorLabel.text = episode.author
            guard let imageURL = URL(string: episode.iconURL?.convertedToHTTPS() ?? "") else { return }
            episodeIconImageView.sd_setImage(with: imageURL)
            miniEpisodeIconImageView.sd_setImage(with: imageURL)
        }
    }
    
    
    
        // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openAudioPlayerView)))
        
        observePlayerCurrentTime()
        
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in // Retain Cycle 1
            print("episode started playing")
            self?.enlargeEpisodeImageView()
        }
    }
    
    static func initFromNib() -> AudioPlayerView {
        return Bundle.main.loadNibNamed("AudioPlayerView", owner: self, options: nil)?.first as! AudioPlayerView
    }
    
    deinit {
        print("PlayerView memory being reclaimed...")
    }
    
    
    
        // MARK: - Methods
    
    @objc func openAudioPlayerView() {
        let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
        mainTabBarController?.openAudioPlayer(episode: nil)
    }
    
    fileprivate func observePlayerCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] (time) in // Retain Cycle 2
            self?.currentTimeLabel.text = time.asDisplayableString()
            let podcastDuration = self?.player.currentItem?.duration
            self?.durationLabel.text = podcastDuration?.asDisplayableString()
            self?.updateCurrentTimeSlider()
        }
    }
    
    fileprivate func updateCurrentTimeSlider() {
        let currentTimeInSeconds = CMTimeGetSeconds(player.currentTime())
        let durationInSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let sliderPercentage = currentTimeInSeconds / durationInSeconds
        self.currentTimeSlider.value = Float(sliderPercentage)
    }
    
    @objc fileprivate func handlePlayPause() {
        print("Playing Pausing")
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButton.setImage(PlayerIcons.Pause, for: .normal)
            miniPlayPauseButton.setImage(PlayerIcons.Pause, for: .normal)
            enlargeEpisodeImageView()
        } else {
            player.pause()
            playPauseButton.setImage(PlayerIcons.Play, for: .normal)
            miniPlayPauseButton.setImage(PlayerIcons.Play, for: .normal)
            shrinkEpisodeImageView()
        }
    }
    
    fileprivate func enlargeEpisodeImageView() {
        UIView.animate(withDuration: 1.1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.episodeIconImageView.transform = .identity
        })
    }
    
    fileprivate func shrinkEpisodeImageView() {
        UIView.animate(withDuration: 1.1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.episodeIconImageView.transform = self.shrunkenImageScale
        })
    }
    
    fileprivate func playEpisode() {
        guard let streamURL = URL(string: episode.streamURL) else { return }
        let playerItem = AVPlayerItem(url: streamURL)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    fileprivate func seekToTime(delta: Int64) {
        let fifteenSeconds = CMTimeMake(value: delta, timescale: 1)
        let forwardSeek = CMTimeAdd(player.currentTime(), fifteenSeconds)
        player.seek(to: forwardSeek)
    }
    
    
    
        // MARK: - Actions
    
    @IBAction func dismissTapped(_ sender: UIButton) {
        let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
        mainTabBarController?.lowerAudioPlayerDetails()
    }
    
    @IBAction func handleCurrentTimeSliderChange(_ sender: UISlider) {
        let playerPercentage = currentTimeSlider.value
        guard let episodeDuration = player.currentItem?.duration else { return }
        let durationInSeconds = CMTimeGetSeconds(episodeDuration)
        let seekTimeInSeconds = Float64(playerPercentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
        
        player.seek(to: seekTime)
    }
    
    @IBAction func rewind15Tapped(_ sender: UIButton) {
        seekToTime(delta: -15)
    }
    
    @IBAction func forward15Tapped(_ sender: UIButton) {
       seekToTime(delta: 15)
    }
    
    @IBAction func handleVolumeChange(_ sender: UISlider) {
        player.volume = sender.value
    }
}
