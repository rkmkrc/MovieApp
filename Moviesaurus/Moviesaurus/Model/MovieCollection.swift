//
//  Movie.swift
//  Moviesaurus
//
//  Created by Erkam Karaca on 26.07.2022.
//

import Foundation

struct MovieCollection: Codable {
    let page: Int?
    let results: [Movie]?
    let totalPages: Int?
    let totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Movie: Codable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int?]?
    let id: Int?
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let popularity: Double?
    let posterPath: String?
    let releaseDate: String?
    let title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case adult, id, overview, popularity, title, video
    }
}

struct Credit: Codable {
    let id: Int?
    let cast: [Person]?
}

struct CastMovies: Codable {
    let id: Int?
    let movies: [Movie]?
    
    enum CodingKeys: String, CodingKey {
        case movies = "cast"
        case id
    }
}


