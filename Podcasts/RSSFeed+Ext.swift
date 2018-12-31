//
//  RSSFeed+Ext.swift
//  Podcasts
//
//  Created by Owen Henley on 12/31/18.
//  Copyright © 2018 Owen Henley. All rights reserved.
//

import Foundation
import FeedKit

extension RSSFeed {
    
    
    /// Convert feed items into an array of Episodes
    ///
    /// - Returns: [Episode]
    func asEpisodes() -> [Episode] {
        let iconURL = iTunes?.iTunesImage?.attributes?.href
        var parsedEpisodes = [Episode]()
        items?.forEach { (feedItem) in
            var parsedEpisode = Episode(feedItem: feedItem)
            
            if parsedEpisode.iconURL == nil {
                parsedEpisode.iconURL = iconURL
            }
            
            parsedEpisodes.append(parsedEpisode)
        }
        return parsedEpisodes
    }
}
