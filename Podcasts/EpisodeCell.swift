//
//  EpisodeCell.swift
//  Podcasts
//
//  Created by Owen Henley on 12/30/18.
//  Copyright © 2018 Owen Henley. All rights reserved.
//

import UIKit

class EpisodeCell: UITableViewCell {

    @IBOutlet weak var episodeIcon: UIImageView!
    @IBOutlet weak var publishedDate: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.numberOfLines = 2
        }
    }
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.numberOfLines = 2
        }
    }
    
    var episode: Episode! {
        didSet {
            // DateHelper.formatDate()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            publishedDate.text = "\(dateFormatter.string(from: episode.pubDate))"
            titleLabel.text = episode?.title
            descriptionLabel.text = episode?.description
            let iconURL = URL(string: episode.iconURL?.convertedToHTTPS() ?? "" )
            episodeIcon.layer.cornerRadius = 3
            episodeIcon.sd_setImage(with: iconURL)
        }
    }
}
