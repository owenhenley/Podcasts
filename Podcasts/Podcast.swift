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

class Podcast: NSObject, Decodable, NSCoding {
    // discontinued in iOS 12
    func encode(with aCoder: NSCoder) {
        print("Trying to transform Podcast into Data")
        aCoder.encode(trackName ?? "", forKey: "trackNameKey")
        aCoder.encode(artistName ?? "", forKey: "artistNameKey")
        aCoder.encode(artworkUrl600 ?? "", forKey: "artworkKey")
    }

    required init?(coder aDecoder: NSCoder) {
        print("Trying to turn Data into Podcast")
        self.trackName = aDecoder.decodeObject(forKey: "trackNameKey") as? String
        self.artistName = aDecoder.decodeObject(forKey: "artistNameKey") as? String
        self.artworkUrl600 = aDecoder.decodeObject(forKey: "artworkKey") as? String
    }

    var trackName: String?
    var artistName: String?
    var artworkUrl600: String?
    var trackCount: Int?
    var feedUrl: String?
}
