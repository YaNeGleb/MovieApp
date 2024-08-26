//
//  Stills.swift
//  MovieApp
//
//  Created by Zabroda Gleb on 26.08.2024.
//

import Foundation

// MARK: - StillsFromMovie
struct Stills: Codable, Equatable {
    let backdrops: [Still]
    let id: Int
    let logos, posters: [Still]
}

// MARK: - Still
struct Still: Codable, Equatable, Identifiable {
    let id = UUID()
    let aspectRatio: Double
    let height: Int
    let iso639_1: String?
    let filePath: String
    let voteAverage: Double
    let voteCount, width: Int
    var filePathURL: URL? {
        return URL(string: "https://image.tmdb.org/t/p/w500/\(filePath)")
    }
    
    enum CodingKeys: String, CodingKey {
        case aspectRatio = "aspect_ratio"
        case height
        case iso639_1 = "iso_639_1"
        case filePath = "file_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case width
    }
}
