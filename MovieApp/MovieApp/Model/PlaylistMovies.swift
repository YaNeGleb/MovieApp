//
//  PlaylistMovies.swift
//  MovieApp
//
//  Created by Zabroda Gleb on 26.08.2024.
//

import Foundation

struct PlaylistMovies: Identifiable, Equatable {
    let id = UUID()
    let type: PlaylistType
    var movies: [Movie]
}

enum PlaylistType: CaseIterable {
    case top10Week
    case popularMovies
    case topRatedMovies
    case upcomingMovies
    case nowPlayingMovies
    case topFamilyMovies
    case topComedyMovies
    case topFilmsOfDecade
    case topFilmsPastYear
    case topActionMovies
    case topHorrorMovies
    case topRomanticMovies

    var title: String {
        switch self {
        case .top10Week: return "Top 10 Week"
        case .popularMovies: return "Popular"
        case .upcomingMovies: return "Upcoming"
        case .topRatedMovies: return "Top Rated"
        case .nowPlayingMovies: return "Now Playing"
        case .topFamilyMovies: return "Top Family Movies"
        case .topComedyMovies: return "Top Comedy Movies"
        case .topFilmsOfDecade: return "Top Films Decade"
        case .topFilmsPastYear: return "The Best Films Past Year"
        case .topActionMovies: return "Top Action Movies"
        case .topHorrorMovies: return "Top Horror Movies"
        case .topRomanticMovies: return "Top Romantic Movies"
        }
    }
}
