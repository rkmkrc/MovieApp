//
//  Cast.swift
//  Moviesaurus
//
//  Created by Erkam Karaca on 5.08.2022.
//

import Foundation

struct Person: Codable {
    let id: Int?
    let name: String?
    let imageURL: String?
    let characterName: String?
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "profile_path"
        case characterName = "character"
        case id, name
    }
}

struct PersonDetails: Codable {
    var id: Int?
    var name: String?
    var imageURL: String?
    var biography: String?
    var birthday: String?
    var deathday: String?
    var placeOfBirth: String?
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "profile_path"
        case placeOfBirth = "place_of_birth"
        case id, name, biography, birthday, deathday
    }
}

struct PersonCollection: Codable {
    let page: Int?
    let results: [PersonInSearch]?
    let totalPages: Int?
    let totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case totalPages = "total_pages"
        case totalResults  = "total_results"
        case page, results
    }
}

struct PersonInSearch: Codable {
    let id: Int?
    let name: String?
    let imageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "profile_path"
        case id, name
    }
}
