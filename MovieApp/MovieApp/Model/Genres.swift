//
//  Genres.swift
//  MovieApp
//
//  Created by Zabroda Gleb on 26.08.2024.
//

import Foundation

// MARK: - Genres
struct Genres: Codable, Equatable {
    let genres: [Genre]
}

// MARK: - Genre
struct Genre: Codable, Equatable {
    let id: Int
    let name: String
}
