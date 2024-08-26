//
//  APIClient.swift
//  MovieApp
//
//  Created by Zabroda Gleb on 26.08.2024.
//

import Foundation
import Alamofire
import ComposableArchitecture

protocol APIClientBaseProtocol {
    func fetchData<T: Decodable>(from endpoint: String) async throws -> T
}

protocol MovieListAPIClientProtocol {
    func fetchMoviesForPlaylist(for playlistType: PlaylistType, page: Int) async throws -> Movies
}

protocol MovieDetailsAPIClientProtocol {
    func fetchDetailsMovie(id: Int) async throws -> MovieDetails
    func fetchStillsMovie(id: Int) async throws -> Stills
    func fetchReviewsForMovieId(movieId: Int) async throws -> Review
    func fetchCreditsForMovieId(movieId: Int) async throws -> Credits
    func fetchRecommendationsForMovieId(movieId: Int) async throws -> Movies
}

protocol MovieConfigurationAPIClientProtocol {
    func fetchAllGenres() async throws -> Genres
}

struct APIClient: APIClientBaseProtocol {
    private let baseURL = "https://api.themoviedb.org/3/"
    private let apiKey = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhN2I4YzExNzlmYTNiOGQ1MDZjOTUxM2U4YmI5MDI4YiIsInN1YiI6IjY0ODFlNmY1ZTM3NWMwMDBlMjRkZmE0OCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.OhxevvXe56DwKQX_s8tgja2s0Xz74hfa6HUvgw9dQWA"
    
    func fetchData<T: Decodable>(from endpoint: String) async throws -> T {
        let url = baseURL + endpoint
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: .get, headers: HTTPHeaders(["Authorization": "Bearer \(apiKey)"])).validate().responseDecodable(of: T.self) { response in
                switch response.result {
                case let .success(data):
                    continuation.resume(returning: data)
                    
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    private func constructEndpoint(for playlistType: PlaylistType, page: Int) -> String {
        let baseEndpoint: String
        switch playlistType {
        case .top10Week:
            baseEndpoint = "trending/movie/week"
        case .topRatedMovies:
            baseEndpoint = "movie/top_rated"
        case .nowPlayingMovies:
            baseEndpoint = "movie/now_playing"
        case .popularMovies:
            baseEndpoint = "movie/popular"
        case .upcomingMovies:
            baseEndpoint = "movie/upcoming"
        case .topFamilyMovies:
            baseEndpoint = "discover/movie?with_genres=10751&sort_by=vote_average.desc&vote_count.gte=1000"
        case .topComedyMovies:
            baseEndpoint = "discover/movie?with_genres=35"
        case .topFilmsOfDecade:
            baseEndpoint = "discover/movie?primary_release_date.gte=1990-01-01&primary_release_date.lte=1999-12-31"
        case .topFilmsPastYear:
            baseEndpoint = "discover/movie?primary_release_year=2023&sort_by=vote_average.desc"
        case .topActionMovies:
            baseEndpoint = "discover/movie?with_genres=28&sort_by=vote_average.desc&vote_count.gte=1000"
        case .topHorrorMovies:
            baseEndpoint = "discover/movie?with_genres=27&sort_by=vote_average.desc&vote_count.gte=1000"
        case .topRomanticMovies:
            baseEndpoint = "discover/movie?with_genres=10749&sort_by=vote_average.desc&vote_count.gte=1000"
        }
        
        return "\(baseEndpoint)?language=en-US&page=\(page)"
    }
    
    private func constructFilteredEndpoint(page: Int, filters: [String: String]) -> String {
        let baseEndpoint = "discover/movie"

        let filterString = filters.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        return "\(baseEndpoint)?page=\(page)&\(filterString)&language=en-US"
    }
}

// MARK: - MovieListAPIClientProtocol
extension APIClient: MovieListAPIClientProtocol {
    func fetchMoviesForPlaylist(for playlistType: PlaylistType, page: Int) async throws -> Movies {
        let endpoint = constructEndpoint(for: playlistType, page: page)
        return try await fetchData(from: endpoint)
    }
}

// MARK: - MovieDetailsAPIClientProtocol
extension APIClient: MovieDetailsAPIClientProtocol {
    func fetchDetailsMovie(id: Int) async throws -> MovieDetails {
        return try await fetchData(from: "movie/\(id)?append_to_response=videos&language=en-US")
    }
    
    func fetchStillsMovie(id: Int) async throws -> Stills {
        return try await fetchData(from: "movie/\(id)/images")
    }
    
    func fetchReviewsForMovieId(movieId: Int) async throws -> Review {
        return try await fetchData(from: "movie/\(movieId)/reviews")
    }
    
    func fetchCreditsForMovieId(movieId: Int) async throws -> Credits {
        return try await fetchData(from: "movie/\(movieId)/credits")
    }
    
    func fetchRecommendationsForMovieId(movieId: Int) async throws -> Movies {
        return try await fetchData(from: "movie/\(movieId)/recommendations")
    }
}

// MARK: - MovieConfigurationAPIClientProtocol
extension APIClient: MovieConfigurationAPIClientProtocol {
    func fetchAllGenres() async throws -> Genres {
        return try await fetchData(from: "genre/movie/list")
    }
}

extension APIClient: DependencyKey {
    static var liveValue = APIClient()
}

extension DependencyValues {
    var apiClient: APIClient {
        get { self[APIClient.self] }
        set { self[APIClient.self] = newValue }
    }
}
