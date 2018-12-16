//
//  MainTabBarController.swift
//  Podcasts
//
//  Created by Owen Henley on 12/14/18.
//  Copyright © 2018 Owen Henley. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
    }
    
        // MARK: - Setup Methods
    
    private func setupNavigation() {
        UINavigationBar.appearance().prefersLargeTitles = true
        tabBar.tintColor = .purple
        viewControllers = [
            generateNavigationController(with: ViewController(), title: "Favorites", andImage: TabBarIcon.Favorites),
            generateNavigationController(with: ViewController(), title: "Search", andImage: TabBarIcon.Search),
            generateNavigationController(with: ViewController(), title: "Downloads", andImage: TabBarIcon.Downloads)
        ]
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
