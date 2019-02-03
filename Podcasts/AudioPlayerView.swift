//
//  AudioPlayerView.swift
//  Podcasts
//
//  Created by Owen Henley on 12/31/18.
//  Copyright © 2018 Owen Henley. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer

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
    
    // Concider using an outlet collection to set button content mode...
    @IBOutlet weak var rewind15Button: UIButton! {
        didSet {
            rewind15Button.contentHorizontalAlignment = .fill
            rewind15Button.contentVerticalAlignment = .fill
            rewind15Button.imageView?.contentMode = .scaleAspectFit
            rewind15Button.setImage(PlayerIcons.Rewind, for: .normal)
        }
    }
    @IBOutlet weak var forward15Button: UIButton! {
        didSet {
            forward15Button.contentHorizontalAlignment = .fill
            forward15Button.contentVerticalAlignment = .fill
            forward15Button.imageView?.contentMode = .scaleAspectFit
            forward15Button.setImage(PlayerIcons.FastForward, for: .normal)
        }
    }
    
    @IBOutlet weak var playPauseButton: UIButton! {
        didSet {
            playPauseButton.contentHorizontalAlignment = .fill
            playPauseButton.contentVerticalAlignment = .fill
            playPauseButton.imageView?.contentMode = .scaleAspectFit
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
    
    private let shrunkenImageScale = CGAffineTransform(scaleX: 0.7, y: 0.7)
    private var panGesture: UIPanGestureRecognizer!
    private var commandCenter = MPRemoteCommandCenter.shared()
    var playlistEpisodes = [Episode]()
    
    // MARK: Computed Properties
    
    private let player: AVPlayer = { // ????????
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
            setupNowPlayingInfo()
            guard let imageURL = URL(string: episode.iconURL?.convertedToHTTPS() ?? "") else { return }
            episodeIconImageView.sd_setImage(with: imageURL)
            miniEpisodeIconImageView.sd_setImage(with: imageURL) { (image, _, _, _) in
                guard let image = image else { return }
                let artwork = MPMediaItemArtwork(boundsSize: .zero, requestHandler: { (size) -> UIImage in
                    return image
                })
                MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyArtwork] = artwork
            }
        }
    }



    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupGestures()
        setupAudioSession()
        setupControlCenter()
        observeBoundryTime()

    }
    
    static func initFromNib() -> AudioPlayerView {
        return Bundle.main.loadNibNamed("AudioPlayerView", owner: self, options: nil)?.first as! AudioPlayerView
    }
    
    deinit {
        print("PlayerView memory being reclaimed...")
    }

    // MARK: - Methods
    
    fileprivate func observeBoundryTime() {
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in // Retain Cycle 1
            print("episode started playing")
            self?.enlargeEpisodeImageView()
            self?.setupLockScreenDuration()
        }
    }
    
    private func setupLockScreenDuration() {
        guard let duration = player.currentItem?.duration else { return }
        let durationSeconds = CMTimeGetSeconds(duration)
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyPlaybackDuration] = durationSeconds
    }
    
    private func setupNowPlayingInfo() {
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = episode.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = episode.author
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    private func setupControlCenter() {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        observePlayerCurrentTime()
        commandCenter.playCommand.isEnabled = true
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.togglePlayPauseCommand.isEnabled = true
        
        commandCenter.playCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.player.play()
            self.playPauseButton.setImage(PlayerIcons.Pause, for: .normal)
            self.miniPlayPauseButton.setImage(PlayerIcons.Pause, for: .normal)
            self.setupElapsedTime()
            return .success
        }
        commandCenter.pauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.player.pause()
            self.playPauseButton.setImage(PlayerIcons.Play, for: .normal)
            self.miniPlayPauseButton.setImage(PlayerIcons.Play, for: .normal)
            self.setupElapsedTime()
            return .success
        }
        commandCenter.togglePlayPauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.handlePlayPause()
            return .success
        }
        commandCenter.nextTrackCommand.addTarget(self, action: #selector(handleNextTrack))
        commandCenter.previousTrackCommand.addTarget(self, action: #selector(handlePreviousTrack))
    }
    
    @objc fileprivate func handleNextTrack() {
        print("next episode")
        if playlistEpisodes.count == 0 {
            return
        }
        
        let currentEpisodeIndex = playlistEpisodes.index { (ep) -> Bool in
            return self.episode.title == ep.title && self.episode.author == ep.author
        }
        
        guard let index = currentEpisodeIndex else { return }
        
        let nextEpisode: Episode
        
        if index == playlistEpisodes.count - 1 {
            nextEpisode = playlistEpisodes[0]
        } else {
            nextEpisode = playlistEpisodes[index + 1]
        }
        self.episode = nextEpisode
    }
    
    @objc fileprivate func handlePreviousTrack() {
        print("previous episode")
        if playlistEpisodes.count == 0 {
            return
        }
        
        let currentEpisodeIndex = playlistEpisodes.index { (episode) -> Bool in
            return self.episode.title == episode.title && self.episode.author == episode.author
        }
        
        guard let index = currentEpisodeIndex else { return }
        
        let previousEpisode: Episode
        
        if index == 0 {
            let count = playlistEpisodes.count
            previousEpisode = playlistEpisodes[count - 1]
        } else {
            previousEpisode = playlistEpisodes[index - 1]
        }
        self.episode = previousEpisode
        
    }
    
    private func setupElapsedTime() {
        let elapsedTime = CMTimeGetSeconds(player.currentTime())
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsedTime
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("❌ ERROR in \(#file), \(#function), \(error),\(error.localizedDescription) ❌")
        }
    }
    
    private func setupGestures() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openAudioPlayerView)))
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        audioPlayerMiniView.addGestureRecognizer(panGesture)
        openedPlayerStackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanDismissal)))
    }
    
    @objc fileprivate func handlePanDismissal(_ gesture: UIPanGestureRecognizer) {
        print("opened stack view dismissal")
        if gesture.state == .changed {
            let translation = gesture.translation(in: superview)
            openedPlayerStackView.transform = CGAffineTransform(translationX: 0, y: translation.y)
        } else if gesture.state == .ended {
            let translation = gesture.translation(in: superview)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.openedPlayerStackView.transform = .identity
                
                if translation.y > 75 {
                    let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
                    mainTabBarController?.lowerAudioPlayerDetails()
                }
            })
        }
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        if gesture.state == .changed {
            handlePanChanged(gesture)
        } else if gesture.state == . ended {
            handlePanEnded(gesture)
        }
    }
    
    private func handlePanChanged(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        self.audioPlayerMiniView.alpha = 1 + translation.y / 200
        self.openedPlayerStackView.alpha = -translation.y / 200
    }
    
    private func handlePanEnded(_ gesture: UIPanGestureRecognizer) {
        let stoppedTranslation = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.transform = .identity
            if stoppedTranslation.y < -200 || velocity.y < -500 {
                UIApplication.mainTabBarController()?.openAudioPlayer(episode: nil)
            } else {
                self.audioPlayerMiniView.alpha = 1
                self.openedPlayerStackView.alpha = 0
            }
        })
    }
    
    @objc func openAudioPlayerView() {
        UIApplication.mainTabBarController()?.openAudioPlayer(episode: nil)
    }
    
    private func observePlayerCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] (time) in // Retain Cycle 2
            self?.currentTimeLabel.text = time.asDisplayableString()
            let podcastDuration = self?.player.currentItem?.duration
            self?.durationLabel.text = podcastDuration?.asDisplayableString()
            self?.updateCurrentTimeSlider()
        }
    }
    
    private func updateCurrentTimeSlider() {
        let currentTimeInSeconds = CMTimeGetSeconds(player.currentTime())
        let durationInSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let sliderPercentage = currentTimeInSeconds / durationInSeconds
        self.currentTimeSlider.value = Float(sliderPercentage)
    }
    
    @objc private func handlePlayPause() {
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
    
    private func enlargeEpisodeImageView() {
        UIView.animate(withDuration: 1.1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.episodeIconImageView.transform = .identity
        })
    }
    
    private func shrinkEpisodeImageView() {
        UIView.animate(withDuration: 1.1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.episodeIconImageView.transform = self.shrunkenImageScale
        })
    }
    
    private func playEpisode() {
        guard let streamURL = URL(string: episode.streamURL) else { return }
        let playerItem = AVPlayerItem(url: streamURL)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    private func seekToTime(delta: Int64) {
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
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = seekTimeInSeconds
        
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
