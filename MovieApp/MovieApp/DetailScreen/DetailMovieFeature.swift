//
//  DetailMovieFeature.swift
//  MovieApp
//
//  Created by Zabroda Gleb on 26.08.2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct DetailMovieFeature {
    @Dependency(\.apiClient) var apiClient
    @Dependency(\.dismiss) var dismiss
    
    @ObservableState
    struct State: Equatable {
        var currentMovie: Movie
        var movieDetails: MovieDetails?
        var stillsFromMovie: [Still] = []
        var recommendationsMovies: Movies?
        var reviews: Review?
        var genres: [Genre]?
        var credits: Credits?
        var selectedIndex: Int = 0
        var isLoading: Bool = false
        var isSaveMovie: Bool = false
        var isShowFullScreenImage: Bool = false
        var isShowingTrailer: Bool = false
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case lifecycle(Lifecycle)
        case dataFetching(DataFetching)
        case navigation(Navigation)
        case saveMovie

        enum Lifecycle {
            case onAppear
        }

        enum DataFetching {
            case fetchMovieDetails(Int)
            case detailsFetched(MovieDetails)
            case fetchReviewsForMovieId(Int)
            case fetchStillsFromMovie(Int)
            case fetchGenresForMovie([Int])
            case fetchCreditsForMovie(Int)
            case fetchRecommendationsForMovieId(Int)
            case genresFetched([Genre])
            case stillsFetched(Stills)
            case reviewsFetched(Review)
            case creditsFetched(Credits)
            case recommendationsFetched(Movies)
        }

        enum Navigation {
            case dismiss
        }
    }

    
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .lifecycle(let lifecycleAction):
                switch lifecycleAction {
                case .onAppear:
                    let movieId = state.currentMovie.id
                    var effects: [Effect<Action>] = [
                        .send(.dataFetching(.fetchMovieDetails(movieId))),
                        .send(.dataFetching(.fetchStillsFromMovie(movieId))),
                        .send(.dataFetching(.fetchGenresForMovie(state.currentMovie.genreIDS))),
                        .send(.dataFetching(.fetchReviewsForMovieId(movieId))),
                        .send(.dataFetching(.fetchCreditsForMovie(movieId))),
                        .send(.dataFetching(.fetchRecommendationsForMovieId(movieId)))
                    ]
                    return .concatenate(effects)
                }
                
            case .dataFetching(let dataFetchingAction):
                switch dataFetchingAction {
                case .fetchMovieDetails(let movieId):
                    state.isLoading = true
                    return .run { send in
                        do {
                            let details = try await apiClient.fetchDetailsMovie(id: movieId)
                            await send(.dataFetching(.detailsFetched(details)))
                        } catch {
                            print("Error fetching movie details: \(error)")
                        }
                    }
                    
                case .detailsFetched(let movieDetails):
                    state.isLoading = false
                    state.movieDetails = movieDetails
                    return .none
                    
                case .fetchGenresForMovie(let genreIds):
                    return .run { send in
                        do {
                            let fetchedGenres = try await apiClient.fetchAllGenres()
                            let matchingGenres = fetchedGenres.genres.filter { genreIds.contains($0.id) }
                            await send(.dataFetching(.genresFetched(matchingGenres)))
                        } catch {
                            print("Error fetching genres for movie: \(error)")
                        }
                    }
                    
                case .genresFetched(let genres):
                    state.genres = genres
                    return .none
                    
                case .fetchStillsFromMovie(let movieId):
                    return .run { send in
                        do {
                            let stills = try await apiClient.fetchStillsMovie(id: movieId)
                            await send(.dataFetching(.stillsFetched(stills)))
                        } catch {
                            print("Error fetching stills for movie: \(error)")
                        }
                    }
                    
                case .stillsFetched(let stills):
                    state.stillsFromMovie = stills.backdrops
                    return .none
                    
                case .fetchReviewsForMovieId(let movieId):
                    return .run { send in
                        do {
                            let reviews = try await apiClient.fetchReviewsForMovieId(movieId: movieId)
                            await send(.dataFetching(.reviewsFetched(reviews)))
                        } catch {
                            print("Error fetching reviews for movie: \(error)")
                        }
                    }
                    
                case .reviewsFetched(let reviews):
                    state.reviews = reviews
                    return .none
                    
                case .fetchCreditsForMovie(let movieId):
                    return .run { send in
                        do {
                            let credits = try await apiClient.fetchCreditsForMovieId(movieId: movieId)
                            await send(.dataFetching(.creditsFetched(credits)))
                        } catch {
                            print("Error fetching credits for movie: \(error)")
                        }
                    }
                    
                case .creditsFetched(let credits):
                    state.credits = credits
                    return .none
                    
                case .fetchRecommendationsForMovieId(let movieId):
                    return .run { send in
                        do {
                            let movies = try await apiClient.fetchRecommendationsForMovieId(movieId: movieId)
                            await send(.dataFetching(.recommendationsFetched(movies)))
                        } catch {
                            print("Error fetching recommendations for movie ID \(movieId): \(error)")
                        }
                    }
                    
                case .recommendationsFetched(let movies):
                    state.recommendationsMovies = movies
                    return .none
                }
                
            case .navigation(let navigationAction):
                switch navigationAction {
                case .dismiss:
                    return .run { _ in
                        await self.dismiss()
                    }
                }
                
            case .saveMovie:
                state.isSaveMovie.toggle()
                return .none
            }
        }
    }
}
