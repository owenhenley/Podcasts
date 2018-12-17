//
//  SearchResults.swift
//  Podcasts
//
//  Created by Owen Henley on 12/17/18.
//  Copyright © 2018 Owen Henley. All rights reserved.
//

import Foundation

struct SearchResults: Decodable {
    let resultCount: Int
    let results: [Podcast]
}
