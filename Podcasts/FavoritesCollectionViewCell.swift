//
//  FavoritesCollectionViewCell.swift
//  Podcasts
//
//  Created by Owen Henley on 2/4/19.
//  Copyright © 2019 Owen Henley. All rights reserved.
//

import UIKit

class FavoritesCollectionViewCell: UICollectionViewCell {
    
    let imageView = UIImageView(image: Icon.Default)
    let nameLabel = UILabel()
    let artistNameLabel = UILabel()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        styleUI()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    private func styleUI() {
        nameLabel.text = "Podcast Name"
        artistNameLabel.text = "Artist Name"
        
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        artistNameLabel.font = UIFont.systemFont(ofSize: 13)
        artistNameLabel.textColor = .lightGray
    }
    
    private func setupViews() {
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        let stackView = UIStackView(arrangedSubviews: [imageView, nameLabel, artistNameLabel])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
