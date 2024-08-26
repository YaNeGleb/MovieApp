//
//  Review.swift
//  MovieApp
//
//  Created by Zabroda Gleb on 26.08.2024.
//

import Foundation

// MARK: - Review
struct Review: Codable, Equatable {
    let id, page: Int
    let results: [ReviewResult]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case id, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - ReviewResult
struct ReviewResult: Codable, Equatable {
    let author: String
    let authorDetails: AuthorDetails
    let content, createdAt, id, updatedAt: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case author
        case authorDetails = "author_details"
        case content
        case createdAt = "created_at"
        case id
        case updatedAt = "updated_at"
        case url
    }
}

// MARK: - AuthorDetails
struct AuthorDetails: Codable, Equatable {
    let name, username: String
    let rating: Int?

    enum CodingKeys: String, CodingKey {
        case name, username
        case rating
    }
}

