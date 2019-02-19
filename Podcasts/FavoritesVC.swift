//
//  FavoritesVC.swift
//  Podcasts
//
//  Created by Owen Henley on 2/4/19.
//  Copyright © 2019 Owen Henley. All rights reserved.
//

import UIKit


class FavoritesVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    // MARK: - Properties
    private let reuseIdentifier = "cellId"
    private var podcasts = UserDefaults.standard.savedPodcasts()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        podcasts = UserDefaults.standard.savedPodcasts()
        collectionView.reloadData()
        UIApplication.mainTabBarController()?.viewControllers?[1].tabBarItem.badgeValue = nil
    }
    
    // MARK: - Helpers
    private func setupCollectionView() {
        collectionView.backgroundColor = .white
        // Register cell classes
        self.collectionView!.register(FavoritesCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // TODO: - Implement UIForceTouchCapability??
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        collectionView.addGestureRecognizer(gesture)
    }

    @objc private func handleLongPress(gesture: UILongPressGestureRecognizer) {
        print("podcast")
        let location = gesture.location(in: collectionView)
        guard let selectedIndexPath = collectionView.indexPathForItem(at: location) else { return }
        print(selectedIndexPath.item)

        let alert = UIAlertController(title: "Delete Saved Podcast?", message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Yes", style: .destructive) { (_) in
            let podcastToDelete = self.podcasts[selectedIndexPath.item]
            self.podcasts.remove(at: selectedIndexPath.item)
            UserDefaults.standard.deletePodcast(podcast: podcastToDelete)
            self.collectionView.deleteItems(at: [selectedIndexPath])
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addAction(deleteAction)
        alert.addAction(cancelAction)

        alert.preferredAction = deleteAction

        present(alert, animated: true)
    }

    // MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return podcasts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? FavoritesCollectionViewCell
        else {
            return UICollectionViewCell()
        }

        cell.podcast = self.podcasts[indexPath.item]

        return cell
    }

    // MARK: - UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let episodesVC = EpisodesVC()
        episodesVC.podcast = self.podcasts[indexPath.item]
        navigationController?.pushViewController(episodesVC, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = (view.frame.width - 3 * 16) / 2
        return CGSize(width: cellSize, height: cellSize + 46)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
