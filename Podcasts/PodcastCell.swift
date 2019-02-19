//
//  PodcastCell.swift
//  Podcasts
//
//  Created by Owen Henley on 12/17/18.
//  Copyright © 2018 Owen Henley. All rights reserved.
//

import UIKit
import SDWebImage

class PodcastCell: UITableViewCell {
    
    @IBOutlet weak var podcastArt: UIImageView!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var episodeCount: UILabel!
    
    var podcast: Podcast! {
        didSet {
            trackName.text = podcast.trackName
            artistName.text  = podcast.artistName
            episodeCount.text = "\(podcast.trackCount ?? 0) Episodes"
            guard let imageURL = URL(string: podcast.artworkUrl600 ?? "") else { return }
            podcastArt.layer.cornerRadius = 3
            podcastArt.sd_setImage(with: imageURL, completed: nil)
            
            // URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
            //     if let error = error {
            //         print("Error in File: \(#file), /nFunction: \(#function), /nLine: \(#line), /nMessage: \(error). \(error.localizedDescription)")
            //         return
            //     }
            //
            //     print(response ?? "")
            //
            //     guard let data = data else { return }
            //
            //     DispatchQueue.main.async {
            //         self.podcastArt.image = UIImage(data: data)
            //     }
            // }.resume()
            
        }
    }
}
