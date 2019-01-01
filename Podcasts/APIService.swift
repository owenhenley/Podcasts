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
                print("❌ ERROR in \(#file), \(#function), \(error),\(error.localizedDescription) ❌")
                return
            }
            
            guard let data = dataResponse.data else { return }
            do {
                let searchResult = try JSONDecoder().decode(SearchResults.self, from: data)
                completionHandler(searchResult.results)
            } catch {
                print("❌ ERROR in \(#file), \(#function), \(error),\(error.localizedDescription) ❌")
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
                    print("❌ ERROR in \(#file), \(#function), \(error),\(error.localizedDescription) ❌")
                    return
                }
                
                guard let feed = result.rssFeed else { return }
                let episodes = feed.asEpisodes()
                completion(episodes)
            }
        }
    }
}
