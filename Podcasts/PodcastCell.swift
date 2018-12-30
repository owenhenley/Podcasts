//
//  PodcastCell.swift
//  Podcasts
//
//  Created by Owen Henley on 12/17/18.
//  Copyright © 2018 Owen Henley. All rights reserved.
//

import UIKit

class PodcastCell: UITableViewCell {
    
    @IBOutlet weak var podcastArt: UIImageView!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var episodeCount: UILabel!
    
    var podcast: Podcast! {
        didSet {
            trackName.text = podcast.trackName
            artistName.text  = podcast.artistName
        }
    }
}
