//
//  MainTabBarController.swift
//  Podcasts
//
//  Created by Owen Henley on 12/14/18.
//  Copyright © 2018 Owen Henley. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
        // MARK: - Properties
    
    private let audioPlayerView = AudioPlayerView.initFromNib()
    private var openedTopAnchorConstraint: NSLayoutConstraint!
    private var loweredTopAnchorConstraint: NSLayoutConstraint!
    private var bottomAnchorConstraint: NSLayoutConstraint!

        // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupAudioPlayerView()
    }

        // MARK: - Setup Methods
    
    private func setupNavigation() {
        UINavigationBar.appearance().prefersLargeTitles = true
        tabBar.tintColor = .purple
        viewControllers = [
            generateNavigationController(with: SearchVC(), title: "Search", andImage: TabBarIcon.Search),
            generateNavigationController(with: ViewController(), title: "Favorites", andImage: TabBarIcon.Favorites),
            generateNavigationController(with: ViewController(), title: "Downloads", andImage: TabBarIcon.Downloads)
        ]
    }
    
    private func setupAudioPlayerView() {
        audioPlayerView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(audioPlayerView, belowSubview: tabBar)
        
        openedTopAnchorConstraint = audioPlayerView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        openedTopAnchorConstraint.isActive = true
        
        bottomAnchorConstraint = audioPlayerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        bottomAnchorConstraint.isActive = true
        
        loweredTopAnchorConstraint = audioPlayerView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        // loweredTopAnchorConstraint.isActive = true
        
        audioPlayerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        audioPlayerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
    }

        // MARK: - Methods
    
    @objc func lowerAudioPlayerDetails() {
        openedTopAnchorConstraint.isActive = false
        bottomAnchorConstraint.constant = view.frame.height
        loweredTopAnchorConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.tabBar.transform = .identity
            self.audioPlayerView.openedPlayerStackView.alpha = 0
            self.audioPlayerView.audioPlayerMiniView.alpha = 1
        })
    }

    func openAudioPlayer(episode: Episode?, playlistEpisodes: [Episode] = []) {
        loweredTopAnchorConstraint.isActive = false
        openedTopAnchorConstraint.isActive = true
        openedTopAnchorConstraint.constant = 0
        bottomAnchorConstraint.constant = 0
        
        if episode != nil {
            audioPlayerView.episode = episode            
        }

        audioPlayerView.playlistEpisodes = playlistEpisodes

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
            self.audioPlayerView.openedPlayerStackView.alpha = 1
            self.audioPlayerView.audioPlayerMiniView.alpha = 0
        })
    }

        // MARK: - Private/Helper Methods
    
    // Navigation View Controller helper maker function
    private func generateNavigationController(with rootViewController: UIViewController, title: String, andImage image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        // navController.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        rootViewController.navigationItem.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        return navController
    }
}
