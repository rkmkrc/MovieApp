//
//  Network.swift
//  Moviesaurus
//
//  Created by Erkam Karaca on 25.07.2022.
//

import Foundation
import AVFoundation

struct NetworkConstants{
    static let apiKeyQueryItem = URLQueryItem(name: "api_key", value: "1a18e4772cd84bffda21cb17b614b869")
    static let languageQueryItem = URLQueryItem(name: NetworkConstants.languageURL, value: NetworkConstants.systemLanguage)
    
    static let baseURL = "https://api.themoviedb.org/3"
    static let baseURLOfPoster = "https://image.tmdb.org/t/p/w500"
    static let apiKey = "?api_key=1a18e4772cd84bffda21cb17b614b869"
    static let popularMoviesURL = "/movie/popular"
    static let searchMoviesURL = "/search/movie"
    static let getMovieURL = "/movie"
    static let getMovieCreditsURL = "/credits"
    static let getRecommendationsURL = "/recommendations"
    static let searchPersonURL = "/search/person"
    static let reviewsURL = "/reviews"
    static var languageURL = "language"
    static let personURL = "/person"
    static let combinedCredits = "/combined_credits"
    static var systemLanguage = NSLocale.current.languageCode ?? "en"
    static var language = languageURL + systemLanguage

}

class Network {
    var page = 0
    var totalPage = 0
    var isPaginating = false
    
    func fetchData<T: Codable>(urlString: String, pagination: Bool = false, expecting: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        
        if pagination && (page < totalPage) {
            isPaginating = true
            page += 1
        } else {
            page = 1
        }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + (pagination ? 0 : 0), execute: {
            guard let url = URL(string: (urlString + (pagination ? "&page=\(self.page)": ""))) else {
                completion(.failure(RMError.customError))
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    do {
                        let result = try JSONDecoder().decode(T.self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(result))
                        }
                        
                    } catch (let error) {
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                } else {
                    if let error = error {
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(.failure(RMError.customError))
                        }
                    }
                }
            }
            
            dataTask.resume()
            if pagination {
                self.isPaginating = false
            }
        })
    }
    
    enum RMError: Error {
        case customError
    }
}


