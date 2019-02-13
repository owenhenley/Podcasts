//
//  UserDefaults+Ext.swift
//  Podcasts
//
//  Created by Owen Henley on 2/13/19.
//  Copyright © 2019 Owen Henley. All rights reserved.
//

import Foundation

extension UserDefaults {

    static let favoritedPodcastKey = "favoritedPodcastKey"
    
    func savedPodcasts() -> [Podcast] {
        guard
            let savedPodcastData = UserDefaults.standard.data(forKey: UserDefaults.favoritedPodcastKey),
            let savedPodcasts = NSKeyedUnarchiver.unarchiveObject(with: savedPodcastData) as? [Podcast]
        else { return [] }
        return savedPodcasts
    }

    func deletePodcast(podcast: Podcast) {
        let podcasts = savedPodcasts()
        let filteredPodcasts = podcasts.filter { (filteredPodcast) -> Bool in
            return filteredPodcast.trackName != podcast.trackName && filteredPodcast.artistName != podcast.artistName
        }
        let data = NSKeyedArchiver.archivedData(withRootObject: filteredPodcasts)
        UserDefaults.standard.set(data, forKey: UserDefaults.favoritedPodcastKey)
    }
}
