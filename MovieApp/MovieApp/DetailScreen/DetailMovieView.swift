//
//  DetailMovieView.swift
//  MovieApp
//
//  Created by Zabroda Gleb on 26.08.2024.
//

import SwiftUI
import ComposableArchitecture
import NukeUI

struct DetailMovieView: View {
    @Bindable var store: StoreOf<DetailMovieFeature>
        
    var body: some View {
        GeometryReader { proxy in
            let headerHeight: CGFloat = proxy.size.height * 0.7
            let width = proxy.size.width
            let buttonSize: CGFloat = 60
            WithPerceptionTracking {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading) {
                        ZStack(alignment: .bottom) {
                            if let posterURL = store.currentMovie.posterURL {
                                LazyImage(url: posterURL) { state in
                                    if let image = state.image {
                                        StretchableImage(image: image, initialHeaderHeight: headerHeight)
                                    } else {
                                        Color.black
                                            .frame(width: width, height: headerHeight)
                                            .overlay(
                                                LoaderDotView()
                                                    .foregroundColor(.white)
                                            )
                                    }
                                }
                            } else {
                                Rectangle()
                                    .fill(Color.white)
                                    .frame(width: width, height: headerHeight)
                                    .cornerRadius(16)
                                    .overlay(
                                        Image("noImage")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 90, height: 90)
                                    )
                            }
                            
                            LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.75), Color.black.opacity(1)]), startPoint: .top, endPoint: .bottom)
                                .frame(height: headerHeight)
                                .opacity(1)
                            
                            VStack {
                                Text(store.currentMovie.title)
                                    .font(.system(size: 30))
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                
                                HStack(spacing: 20) {
                                    Button(action: {
                                        store.send(.saveMovie)
                                    }) {
                                        ZStack {
                                            Circle()
                                                .foregroundColor(Color.darkGray.opacity(1))
                                                .frame(width: buttonSize, height: buttonSize)
                                            
                                            Image(systemName: store.isSaveMovie ? "heart.fill" : "heart")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 20, height: 20)
                                                .foregroundColor(store.isSaveMovie ? Color.red : Color.white)
                                        }
                                    }
                                    
                                    Button(action: {
                                        store.isShowingTrailer.toggle()
                                    }) {
                                        ZStack {
                                            Circle()
                                                .foregroundColor(Color.gray.opacity(1))
                                                .frame(width: buttonSize, height: buttonSize)
                                            
                                            Image(systemName: "play")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 20, height: 20)
                                                .foregroundColor(Color.white)
                                        }
                                    }
                                    
                                    Button(action: {
                                        // need add action
                                    }) {
                                        ZStack {
                                            Circle()
                                                .foregroundColor(Color.darkGray.opacity(1))
                                                .frame(width: buttonSize, height: buttonSize)
                                            
                                            Image(systemName: "paperplane")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 20, height: 20)
                                                .foregroundColor(Color.white)
                                        }
                                    }
                                }
                                
                                if let movieDetails = store.movieDetails {
                                    let releaseYear = String(movieDetails.releaseDate.prefix(4))
                                    let countries = movieDetails.productionCountries.map { $0.name }.joined(separator: ", ")
                                    let ageRating = movieDetails.adult ? "18 +" : "0 +"
                                    
                                    Text("\(releaseYear) ⚬ \(countries) ⚬ \(movieDetails.runtime) min ⚬ \(ageRating)")
                                        .font(.system(size: 14))
                                        .fontWeight(.regular)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.gray)
                                        .padding(.top, 15)
                                } else {
                                    Text("No info about movie")
                                        .font(.system(size: 14))
                                        .fontWeight(.regular)
                                        .foregroundColor(.gray)
                                        .padding(.top, 15)
                                }
                                
                                HStack(alignment: .center, spacing: 10) {
                                    if let genres = store.genres {
                                        displayGenres(genres: genres.prefix(3).map { $0.name })
                                    } else {
                                        let notFoundArray = ["Genres not found"]
                                        displayGenres(genres: notFoundArray)
                                    }
                                }
                                .padding(.bottom, 15)
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        VStack {
                            if !store.currentMovie.overview.isEmpty {
                                SectionView(title: "Description") {
                                    Text(store.currentMovie.overview)
                                        .font(.system(size: 16))
                                        .fontWeight(.regular)
                                        .lineLimit(nil)
                                        .foregroundColor(.gray)
                                        .padding(.top, 5)
                                }
                            }
                            
                            if !store.stillsFromMovie.isEmpty {
                                SectionView(title: "Images") {
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        LazyHStack {
                                            ForEach(store.stillsFromMovie, id: \.id) { still in
                                                if let filePathURL = still.filePathURL {
                                                    StillFromMovieRow(filePathURL: filePathURL)
                                                } else {
                                                    Text("Invalid URL")
                                                        .foregroundColor(.red)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            
                            
                            if let reviews = store.reviews?.results, !reviews.isEmpty {
                                SectionView(title: "Reviews", showAllButton: true, onAllButtonPressed: {
                                }) {
                                    ForEach(reviews.suffix(3), id: \.id) { review in
                                        ReviewRow(review: review,
                                                  width: width - 40,
                                                  height: 100)
                                    }
                                }
                            } else {
                                SectionView(title: "Reviews") {
                                    Text("No reviews yet, be the first to comment!")
                                        .font(.system(size: 16)).bold()
                                        .fontWeight(.regular)
                                        .foregroundColor(.gray)
                                    
                                    Button(action: {
                                        
                                    }) {
                                        Text("Write a review")
                                            .font(.headline)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            
                            
                            if let credits = store.credits?.cast, !credits.isEmpty {
                                SectionView(title: "Actors and creators") {
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        LazyHStack {
                                            ForEach(credits.prefix(20), id: \.id) { cast in
                                                Button(action: {

                                                }) {
                                                    CreditRow(cast: cast, width: 90, height: 120)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            
                            if let recommendations = store.recommendationsMovies?.results, !recommendations.isEmpty {
                                SectionView(title: "See more") {
                                    LazyVStack(alignment: .leading, spacing: 10) {
                                        ForEach(0..<recommendations.count / 3, id: \.self) { rowIndex in
                                            HStack(spacing: 15) {
                                                ForEach(recommendations[rowIndex * 3..<min((rowIndex + 1) * 3, recommendations.count)], id: \.id) { movie in
                                                    RecommendationMovieCell(movie: movie,
                                                                            width: (width - 70) / 3,
                                                                            height: ((width - 70) / 3) * 1.4)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.top, 10)
                        .zIndex(0)
                    }
                    .overlay(alignment: .top) {
                        HeaderView(safeArea: proxy.safeAreaInsets, size: proxy.size, title: store.currentMovie.title,
                                   animated: true, sizeToAnimated: proxy.size.height * 0.55) {
                            store.send(.navigation(.dismiss))
                        }
                    }
                    .navigationBarHidden(true)
                }
                .scrollIndicators(.hidden)
                .onAppear {
                    store.send(.lifecycle(.onAppear))
                }
                .edgesIgnoringSafeArea(.top)
            }
        }
    }
    
    private func displayGenres(genres: [String]) -> some View {
        ForEach(genres, id: \.self) { genre in
            Text(genre)
                .font(.system(size: 16))
                .fontWeight(.regular)
                .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                .foregroundColor(.gray)
                .background(Color.black)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray, lineWidth: 1)
                )
        }
    }
}
