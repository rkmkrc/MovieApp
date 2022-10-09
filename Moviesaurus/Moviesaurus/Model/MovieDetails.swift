//
//  GetAMovieElement.swift
//  Moviesaurus
//
//  Created by Erkam Karaca on 2.08.2022.
//

import Foundation

struct MovieDetails: Codable {
    let originalTitle: String?
    let originalLanguage: String?
    let releaseDate: String?
    let budget: Int?
    let genres: [Genre]?
    let overview: String?
    let runtime: Int?
    let productionCompanies: [ProductionCompany]?
    let homePageLink: String?
    let imdb: Double?
    let revenue: Int?
    
    enum CodingKeys: String, CodingKey {
        case originalTitle = "original_title"
        case originalLanguage = "original_language"
        case releaseDate = "release_date"
        case productionCompanies = "production_companies"
        case homePageLink = "homepage"
        case imdb = "vote_average"
        case budget, genres, overview, runtime, revenue
    }
}

struct Genre: Codable {
    let id: Int?
    let name: String?
}

struct ProductionCompany: Codable {
    let name: String?
    let id: Int?
    let logoPath: String?
    let originCountry: String?
    
    enum CodingKeys: String, CodingKey {
        case logoPath = "logo_path"
        case originCountry = "origin_country"
        case name, id
    }
}
