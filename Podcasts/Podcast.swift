//
//  Podcast.swift
//  Podcasts
//
//  Created by Owen Henley on 12/16/18.
//  Copyright © 2018 Owen Henley. All rights reserved.
//

import Foundation

struct SearchResults: Decodable {
    let resultCount: Int
    let results: [Podcast]
}

struct Podcast: Decodable {
    var trackName: String?
    var artistName: String?
    var artworkUrl600: String?
    var trackCount: Int?
    var feedUrl: String?
}
