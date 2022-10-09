//
//  Review.swift
//  Moviesaurus
//
//  Created by Erkam Karaca on 17.08.2022.
//

import Foundation

struct ReviewCollection: Codable {
    let id: Int?
    let page: Int?
    let totalPages: Int?
    let totalResults: Int?
    let reviews: [Review]?
    
    enum CodingKeys: String, CodingKey {
        case id, page
        case totalPages = "total_pages"
        case totalResults = "total_results"
        case reviews = "results"
    }
}

struct Review: Codable {
    let id: String?
    let author: String?
    let authorDetails: AuthorDetails?
    let content: String?
    let creationDate: String?
    let updatedDate: String?
    
    enum CodingKeys: String, CodingKey {
        case authorDetails = "author_details"
        case creationDate = "created_at"
        case updatedDate = "updated_at"
        case id, author, content
    }
}

struct AuthorDetails: Codable {
    let username: String?
    let avatarPath: String?
    let rating: Int?
    
    enum CodingKeys: String, CodingKey {
        case avatarPath = "avatar_path"
        case username, rating
    }
}
