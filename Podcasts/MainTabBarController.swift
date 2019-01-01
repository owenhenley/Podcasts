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
    
    let audioPlayerView = AudioPlayerView.initFromNib()
    var openedTopAnchorConstraint: NSLayoutConstraint!
    var loweredTopAnchorConstraint: NSLayoutConstraint!
    
    
    
        // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupAudioPlayerView()
    }
    
    
    
        // MARK: - Setup Methods
    
    fileprivate func setupNavigation() {
        UINavigationBar.appearance().prefersLargeTitles = true
        tabBar.tintColor = .purple
        viewControllers = [
            generateNavigationController(with: SearchVC(), title: "Search", andImage: TabBarIcon.Search),
            generateNavigationController(with: ViewController(), title: "Favorites", andImage: TabBarIcon.Favorites),
            generateNavigationController(with: ViewController(), title: "Downloads", andImage: TabBarIcon.Downloads)
        ]
    }
    
    fileprivate func setupAudioPlayerView() {
        // audioPlayerView.backgroundColor = .red
        audioPlayerView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(audioPlayerView, belowSubview: tabBar)
        
        openedTopAnchorConstraint = audioPlayerView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        openedTopAnchorConstraint.isActive = true
        loweredTopAnchorConstraint = audioPlayerView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        // loweredTopAnchorConstraint.isActive = true
        
        audioPlayerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        audioPlayerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        audioPlayerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    
    
        // MARK: - Methods
    
    @objc func lowerAudioPlayerDetails() {
        openedTopAnchorConstraint.isActive = false
        loweredTopAnchorConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.tabBar.transform = .identity
            self.audioPlayerView.openedPlayerStackView.isHidden = true
            self.audioPlayerView.audioPlayerMiniView.isHidden = false
        })
    }
    
    func openAudioPlayer(episode: Episode?) {
        openedTopAnchorConstraint.isActive = true
        openedTopAnchorConstraint.constant = 0
        loweredTopAnchorConstraint.isActive = false
        
        if episode != nil {
            audioPlayerView.episode = episode            
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
            self.audioPlayerView.openedPlayerStackView.isHidden = false
            self.audioPlayerView.audioPlayerMiniView.isHidden = true
        })
    }
    
    
    
        // MARK: - Helper Methods
    
    // Navigation View Controller helper maker function
    fileprivate func generateNavigationController(with rootViewController: UIViewController, title: String, andImage image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        // navController.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        rootViewController.navigationItem.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        return navController
    }
    
    
}
