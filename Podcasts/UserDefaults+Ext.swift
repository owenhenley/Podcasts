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
    static let downloadedEpisodesKey = "downloadedEpisodesKey"

    func deleteEpisode(episode: Episode) {
        let savedEpisodes = downloadedEpisodes()
        let filteredEpisodes = savedEpisodes.filter { (filteredEpisode) -> Bool in
            // you should use episode.collectionId to be safer with deletes
            return filteredEpisode.title != episode.title
        }

        do {
            let data = try JSONEncoder().encode(filteredEpisodes)
            UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodesKey)
        } catch {
            print("❌ Error in File: \(#file), Function: \(#function), Line: \(#line), Message: \(error). \(error.localizedDescription) ❌")
        }
    }

    func downloadEpisode(episode: Episode) {
        do {
            var episodes = downloadedEpisodes()
            episodes.insert(episode, at: 0)
            let data = try JSONEncoder().encode(episodes)
            UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodesKey)
        } catch {
            print("❌ Error in File: \(#file), Function: \(#function), Line: \(#line), Message: \(error). \(error.localizedDescription) ❌")
        }
    }

    func downloadedEpisodes() -> [Episode] {
        guard let episodesData = data(forKey: UserDefaults.downloadedEpisodesKey) else { return [] }
        do {
            let episodes = try JSONDecoder().decode([Episode].self, from: episodesData)
            return episodes
        } catch {
            print("❌ Error in File: \(#file), /nFunction: \(#function), /nLine: \(#line), /nMessage: \(error). \(error.localizedDescription) ❌")
        }
        return []
    }

    func savedPodcasts() -> [Podcast] {
        guard let savedPodcastsData = UserDefaults.standard.data(forKey: UserDefaults.favoritedPodcastKey) else {
            return []
        }

        guard let savedPodcasts = NSKeyedUnarchiver.unarchiveObject(with: savedPodcastsData) as? [Podcast] else {
            return []
        }

        return savedPodcasts
    }

    func deletePodcast(podcast: Podcast) {
        let podcasts = savedPodcasts()
        let filteredPodcasts = podcasts.filter { (filteredPodcast) -> Bool in
            return filteredPodcast.trackName != podcast.trackName
                && filteredPodcast.artistName != podcast.artistName
        }
        let data = NSKeyedArchiver.archivedData(withRootObject: filteredPodcasts)
        UserDefaults.standard.set(data, forKey: UserDefaults.favoritedPodcastKey)
    }
}
