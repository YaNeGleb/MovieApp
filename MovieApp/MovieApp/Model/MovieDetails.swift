//
//  MovieDetails.swift
//  MovieApp
//
//  Created by Zabroda Gleb on 26.08.2024.
//

import Foundation

// MARK: - MovieDetails
struct MovieDetails: Decodable, Equatable {
    let adult: Bool
    let backdropPath: String
    let budget: Int
    let genres: [Genre]
    let homepage: String
    let id: Int
    let imdbID, originalLanguage, originalTitle, overview: String
    let popularity: Double
    let posterPath: String
    let releaseDate: String
    let revenue, runtime: Int
    let productionCountries: [ProductionCountry]
    let status, tagline, title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    var posterURL: URL? {
        return URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)")
    }
    var backdropURL: URL? {
        return URL(string: "https://image.tmdb.org/t/p/w500/\(backdropPath)")
    }
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case budget, genres, homepage, id
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case productionCountries = "production_countries"
        case revenue, runtime
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

// MARK: - ProductionCountry
struct ProductionCountry: Decodable, Equatable {
    let iso3166_1, name: String

    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
}
