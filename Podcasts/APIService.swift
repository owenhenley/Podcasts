//
//  APIService.swift
//  Podcasts
//
//  Created by Owen Henley on 12/17/18.
//  Copyright © 2018 Owen Henley. All rights reserved.
//

import Foundation
import Alamofire
import FeedKit

class APIService {
    
    // MARK: - Properties
    let baseiTunesSearchURL = "https://itunes.apple.com/search"
    static let shared = APIService()
    
    
    // MARK: - Methods
    func fetchPodcasts(searchText: String, completionHandler: @escaping ([Podcast]) -> ()) {
        let parameters = ["term": searchText, "media": "podcast"]

        Alamofire.request(baseiTunesSearchURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            if let error = dataResponse.error {
                print("❌ Error in File: \(#file), /nFunction: \(#function), /nLine: \(#line), /nMessage: \(error). \(error.localizedDescription) ❌")
                return
            }
            
            guard let data = dataResponse.data else { return }
            do {
                let searchResult = try JSONDecoder().decode(SearchResults.self, from: data)
                completionHandler(searchResult.results)
            } catch {
                print("❌ Error in File: \(#file), /nFunction: \(#function), /nLine: \(#line), /nMessage: \(error). \(error.localizedDescription) ❌")
            }
        }
    }
    
    func fetchEpisodes(feedURL: String, completion: @escaping ([Episode]) -> ()) {
        let secureFeedURL = feedURL.convertedToHTTPS()
        guard let url = URL(string: secureFeedURL) else { return }
        DispatchQueue.global(qos: .background).async {
            let feedParser = FeedParser(URL: url)
            feedParser.parseAsync { (result) in
                print("Success:", result.isSuccess)
                
                if let error = result.error {
                    print("❌ Error in File: \(#file), /nFunction: \(#function), /nLine: \(#line), /nMessage: \(error). \(error.localizedDescription) ❌")
                    return
                }
                
                guard let feed = result.rssFeed else { return }
                let episodes = feed.asEpisodes()
                completion(episodes)
            }
        }
    }

    func downloadEpisode(episode: Episode) {
        print("downlading \(episode.title ?? ""), Stream url: \(episode.streamURL)")
        let downloadRequest = DownloadRequest.suggestedDownloadDestination()
        Alamofire.download(episode.streamURL, to: downloadRequest).downloadProgress { (progress) in
            print(progress.fractionCompleted)
            }.response { (response) in
                print(response.destinationURL?.absoluteString ?? "")
                var downloadedEpisodes = UserDefaults.standard.downloadedEpisodes()
                guard let index = downloadedEpisodes.firstIndex(where: {
                    $0.title == episode.title &&
                    $0.author == episode.author
                }) else {
                    return
                }
                downloadedEpisodes[index].fileURL = response.destinationURL?.absoluteString ?? ""

                do {
                    let data = try JSONEncoder().encode(downloadedEpisodes)
                    UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodesKey)
                } catch {
                    print("❌ Error in File: \(#file), /nFunction: \(#function), /nLine: \(#line), /nMessage: \(error). \(error.localizedDescription) ❌")
                }
        }
    }
}
