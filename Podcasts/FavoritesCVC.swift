//
//  FavoritesCVC.swift
//  Podcasts
//
//  Created by Owen Henley on 2/4/19.
//  Copyright © 2019 Owen Henley. All rights reserved.
//

import UIKit


class FavoritesCVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private let reuseIdentifier = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
        // MARK: - Helpers
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .white
        // Register cell classes
        self.collectionView!.register(FavoritesCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    // MARK: - Navigation
    
    

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }

    // MARK: UICollectionViewDelegate
    
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
