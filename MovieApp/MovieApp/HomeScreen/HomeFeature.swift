//
//  HomeFeature.swift
//  MovieApp
//
//  Created by Zabroda Gleb on 26.08.2024.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct HomeFeature {
    @Reducer(state: .equatable)
    enum Path {
        case detailScreen(DetailMovieFeature)
    }
    
    @ObservableState
    struct State: Equatable {
        var path = StackState<Path.State>()
        var playlists: [PlaylistMovies] = []
        var isLoading: Bool = false
        var currentPage = 0
        var firstThreeMovies: [MovieWithGenres] = []
    }
    
    enum Action: BindableAction {
        case binding(_ action: BindingAction<State>)
        case lifecycle(Lifecycle)
        case dataFetching(DataFetching)
        case navigation(Navigation)
        case path(StackAction<Path.State, Path.Action>)
        
        enum Lifecycle {
            case onAppear
            case startTimer
            case timerTick
        }
        
        enum DataFetching {
            case fetchPlaylists
            case playlistFetched(Result<PlaylistMovies, Error>)
            case fetchGenresForMovies([Movie])
            case genresFetched([String], Int)
        }
        
        enum Navigation {
            case goToDetailScreen(Movie)
        }
    }
    
    @Dependency(\.apiClient) var apiClient
    @Dependency(\.continuousClock) var clock
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .lifecycle(let lifecycleAction):
                switch lifecycleAction {
                case .onAppear:
                    var effects: [Effect<Action>] = []
                    if state.playlists.isEmpty {
                        effects.append(.send(.dataFetching(.fetchPlaylists)))
                        effects.append(.send(.lifecycle(.startTimer)))
                    }
                    return .concatenate(effects)
                    
                case .startTimer:
                    return .run { send in
                        for await _ in self.clock.timer(interval: .seconds(30)) {
                            await send(.lifecycle(.timerTick))
                        }
                    }
                    
                case .timerTick:
                    state.currentPage = (state.currentPage + 1) % 3
                    return .none
                }
                
            case .dataFetching(let dataFetchingAction):
                switch dataFetchingAction {
                case .fetchPlaylists:
                    return .run { send in
                        do {
                            for type in PlaylistType.allCases {
                                let movies = try await apiClient.fetchMoviesForPlaylist(for: type, page: 1)
                                await send(.dataFetching(.playlistFetched(.success(PlaylistMovies(type: type, movies: movies.results)))))
                            }
                        } catch {
                            await send(.dataFetching(.playlistFetched(.failure(error))))
                        }
                    }
                    
                case .playlistFetched(let result):
                    switch result {
                    case .success(let fetchedPlaylist):
                        state.playlists.append(fetchedPlaylist)
                        if state.playlists.count == 1, let firstPlaylist = state.playlists.first {
                            let firstThreeMovies = Array(firstPlaylist.movies.prefix(3))
                            state.firstThreeMovies = firstThreeMovies.map { MovieWithGenres(movie: $0, genres: []) }
                            return .send(.dataFetching(.fetchGenresForMovies(firstThreeMovies)))
                        }
                        return .none
                        
                    case .failure(let error):
                        state.isLoading = false
                        print("Failed to fetch movies: \(error)")
                        return .none
                    }
                    
                case .fetchGenresForMovies(let movies):
                    return .run { send in
                        for (index, movie) in movies.enumerated() {
                            do {
                                let fetchedGenres = try await apiClient.fetchAllGenres()
                                let matchingGenres = fetchedGenres.genres.filter { genre in
                                    movie.genreIDS.contains(genre.id)
                                }
                                let genres = matchingGenres.map { $0.name }
                                await send(.dataFetching(.genresFetched(genres, index)))
                            } catch {
                                print("Error fetching genres for movie: \(error)")
                            }
                        }
                    }
                    
                case .genresFetched(let genres, let index):
                    state.isLoading = false
                    if index < state.firstThreeMovies.count {
                        state.firstThreeMovies[index].genres = genres
                    }
                    return .none
                }
                
            case .navigation(let navigationAction):
                switch navigationAction {
                case .goToDetailScreen(let movie):
                    state.path.append(.detailScreen(DetailMovieFeature.State(currentMovie: movie)))
                    return .none
                }
            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}
