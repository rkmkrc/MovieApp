//
//  UrlManager.swift
//  Moviesaurus
//
//  Created by Erkam Karaca on 1.09.2022.
//

import Foundation

class UrlManager{
    var urlComponents = URLComponents()
    static var queryItems = [
        NetworkConstants.apiKeyQueryItem,
        NetworkConstants.languageQueryItem
    ]
    
    func setup(tempQueryItems: [URLQueryItem] = UrlManager.queryItems, path: String) {
        urlComponents.scheme = "https"
        urlComponents.host = "api.themoviedb.org"
        urlComponents.path = "/3" + path
        urlComponents.queryItems = tempQueryItems
    }
    
    func getUrl() -> String {
        return urlComponents.url?.absoluteString ?? ""
    }
}
