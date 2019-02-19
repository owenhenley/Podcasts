//
//  Episode.swift
//  Podcasts
//
//  Created by Owen Henley on 12/30/18.
//  Copyright © 2018 Owen Henley. All rights reserved.
//

import Foundation
import FeedKit

struct Episode: Codable {
    let title: String
    let author: String
    let pubDate: Date
    let description: String?
    var iconURL: String?
    let streamURL: String
    var fileURL: String?
    
    init(feedItem: RSSFeedItem) {
        self.title = feedItem.title ?? ""
        self.author = feedItem.iTunes?.iTunesAuthor ?? ""
        self.pubDate = feedItem.pubDate ?? Date()
        self.description = feedItem.iTunes?.iTunesSubtitle ?? feedItem.description
        self.iconURL = feedItem.iTunes?.iTunesImage?.attributes?.href ?? ""
        self.streamURL = feedItem.enclosure?.attributes?.url ?? ""
    }
}
