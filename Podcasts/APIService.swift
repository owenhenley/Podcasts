//
//  APIService.swift
//  Podcasts
//
//  Created by Owen Henley on 12/17/18.
//  Copyright © 2018 Owen Henley. All rights reserved.
//

import Foundation
import Alamofire

class APIService {
    
        // MARK: - Properties
    
    static let shared = APIService()
    let baseiTunesSearchURL = "https://itunes.apple.com/search"
    
    
        // MARK: - Methods
    
    func fetchPodcasts(searchText: String, completion: @escaping ([Podcast]) -> ()) {
        let parameters = ["term" : searchText, "media" : "podcasts"]
        
        Alamofire.request(baseiTunesSearchURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { (response) in
            
            if let error = response.error {
                print("❌ ERROR in \(#file), \(#function), \(error),\(error.localizedDescription) ❌")
                return
            }
            
            guard let data = response.data else { return }
            
            do {
                let searchResults = try JSONDecoder().decode(SearchResults.self, from: data)
                searchResults.results.forEach({ (podcast) in
                })
                completion(searchResults.results)
            } catch {
                print("❌ ERROR in \(#file), \(#function), \(error),\(error.localizedDescription) ❌")
                return
            }
        }
    }
}
