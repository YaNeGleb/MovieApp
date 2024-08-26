//
//  Movies.swift
//  MovieApp
//
//  Created by Zabroda Gleb on 26.08.2024.
//

import Foundation

// MARK: - Movies
struct Movies: Decodable, Equatable {
    let page: Int
    let results: [Movie]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Movie
struct Movie: Decodable, Equatable, Hashable, Identifiable {
    let adult: Bool
    let backdropPath: String?
    let genreIDS: [Int]
    let id: Int
    let originalLanguage, originalTitle, overview: String
    let popularity: Double
    let posterPath: String?
    let releaseDate, title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    let genres: [String]?
    var posterURL: URL? {
        guard let posterPath = posterPath else {
            return nil
        }
        return URL(string: "https://image.tmdb.org/t/p/original/\(posterPath)")
    }
    var backdropURL: URL? {
        guard let backdropPath = backdropPath else {
            return nil
        }
        return URL(string: "https://image.tmdb.org/t/p/original/\(backdropPath)")
    }
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case genres
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

extension Movie {
    init(from movieDetails: MovieDetails, likeUsers: [String], genres: [String]) {
        self.adult = movieDetails.adult
        self.backdropPath = movieDetails.backdropPath
        self.genreIDS = movieDetails.genres.map { $0.id }
        self.id = movieDetails.id
        self.originalLanguage = movieDetails.originalLanguage
        self.originalTitle = movieDetails.originalTitle
        self.overview = movieDetails.overview
        self.popularity = movieDetails.popularity
        self.posterPath = movieDetails.posterPath
        self.releaseDate = movieDetails.releaseDate
        self.title = movieDetails.title
        self.video = movieDetails.video
        self.voteAverage = movieDetails.voteAverage
        self.voteCount = movieDetails.voteCount
        self.genres = genres
    }
}


struct MovieWithGenres: Equatable {
    let movie: Movie
    var genres: [String]
}


