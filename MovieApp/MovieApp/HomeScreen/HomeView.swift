//
//  HomeView.swift
//  MovieApp
//
//  Created by Zabroda Gleb on 26.08.2024.
//

import SwiftUI
import ComposableArchitecture
import NukeUI

struct HomeView: View {
    @Bindable var store: StoreOf<HomeFeature>
    
    var body: some View {
        GeometryReader { proxy in
            WithPerceptionTracking {
                let headerHeight = proxy.size.height * 0.6
                NavigationStackStore(self.store.scope(state: \.path, action: \.path)) {
                    ScrollView(showsIndicators: false) {
                        if store.isLoading {
                            SkeletonForHomeView(headerHeight: headerHeight)
                        } else {
                            VStack(spacing: 0) {
                                TabView(selection: $store.currentPage) {
                                    ForEach(Array(store.firstThreeMovies.enumerated()), id: \.element.movie.id) { index, movieWithGenres in
                                        Button {
                                            store.send(.navigation(.goToDetailScreen(movieWithGenres.movie)))
                                        } label: {
                                            HomePostersView(movieWithGenres: movieWithGenres)
                                        }
                                        .tag(index)
                                    }
                                }
                                .transition(.slide)
                                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                                .frame(height: headerHeight)
                                .cornerRadius(10)
                                .padding(EdgeInsets(top: 20, leading: 10, bottom: 0, trailing: 10))
                                .overlay(
                                    DotIndicatorView(selectedPage: $store.currentPage,
                                                     pages: store.firstThreeMovies.count)
                                    .padding(.bottom, 5), alignment: .bottom
                                )
                                
                                HStack(spacing: 15) {
                                    Button {
                                        
                                    } label: {
                                        HStack {
                                            Image(systemName: "play.fill")
                                                .foregroundColor(.black)
                                            Text("Create")
                                                .font(.system(size: 16)).bold()
                                                .fontWeight(.regular)
                                                .foregroundColor(.black)
                                        }
                                        .frame(height: 54)
                                        .frame(maxWidth: .infinity)
                                        .background(Color.mainPurple)
                                        .cornerRadius(27)
                                    }
                                    
                                    Button {
                                        
                                    } label: {
                                        HStack {
                                            Image(systemName: "plus")
                                                .foregroundColor(.black)
                                            Text("Connect")
                                                .font(.system(size: 16)).bold()
                                                .fontWeight(.regular)
                                                .foregroundColor(.black)
                                        }
                                        .frame(height: 54)
                                        .frame(maxWidth: .infinity)
                                        .background(Color.white)
                                        .cornerRadius(27)
                                    }
                                }
                                .padding(.top, 5)
                                .padding(.horizontal, 15)
                                
                                LazyVStack(spacing: 10) {
                                    ForEach(Array(store.playlists.enumerated()), id: \.element.id) { playlistIndex, playlist in
                                        let (cellWidth, cellHeight) = calculateCellDimensions(for: playlistIndex, screenWidth: proxy.size.width)
                                        
                                        VStack(alignment: .leading, spacing: 15) {
                                            HStack {
                                                Text(playlist.type.title)
                                                    .font(.title2)
                                                    .bold()
                                                    .foregroundColor(.white)
                                                
                                                Spacer()
                                                
                                                Button(action: {}) {
                                                    Text("All")
                                                        .font(.system(size: 17)).bold()
                                                        .fontWeight(.regular)
                                                        .padding(5)
                                                        .foregroundColor(.mainPurple)
                                                }
                                            }
                                            .padding(.horizontal, 10)
                                            
                                            ScrollView(.horizontal, showsIndicators: false) {
                                                LazyHStack(spacing: 15) {
                                                    ForEach(Array(playlist.movies.enumerated()), id: \.element.id) { movieIndex, movie in
                                                        Button(action: {
                                                            store.send(.navigation(.goToDetailScreen(movie)))
                                                        }) {
                                                            if isLargeCell(for: playlistIndex) {
                                                                LargeMovieRow(movie: movie, width: cellWidth, height: cellHeight)
                                                            } else {
                                                                MovieRow(movie: movie, width: cellWidth, height: cellHeight)
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        .padding(.top, 15)
                                        .padding(.bottom, 25)
                                        .padding(.horizontal, 10)
                                        .background(Color.darkGray)
                                        .cornerRadius(16)
                                        .frame(maxWidth: .infinity)
                                    }
                                }
                                .padding(.top, 20)
                                Spacer()
                                
                            }
                            .padding(.top, 30)
                        }
                    }
                    .overlay(alignment: .top, content: {
                        HStack(alignment: .top) {
                            Text("MovieApp")
                                .font(.system(size: 24))
                                .bold()
                                .foregroundColor(.mainPurple)
                            
                            Spacer()
                            
                            Button(action: {
                                
                            }) {
                                Image(systemName: "magnifyingglass")
                                    .imageScale(.large)
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 5)
                        .background(.black)
                    })
                    .onAppear {
                        store.send(.lifecycle(.onAppear))
                    }
                    .background(.black)
                } destination: { store in
                    switch store.case {
                    case let .detailScreen(detailScreenStore):
                        DetailMovieView(store: detailScreenStore)
                    }
                }
            }
        }
    }
    
    private func calculateCellDimensions(for index: Int, screenWidth: CGFloat) -> (CGFloat, CGFloat) {
        let cellWidth: CGFloat = (index == 0 || (index + 1) % 4 == 0) ? screenWidth / 1.6 : screenWidth / 3
        let cellHeight: CGFloat = (index == 0 || (index + 1) % 4 == 0) ? cellWidth / 1.5 : cellWidth * 1.4
        return (cellWidth, cellHeight)
    }
    
    private func isLargeCell(for index: Int) -> Bool {
        return index == 0 || (index + 1) % 4 == 0
    }
}

private struct HomePostersView: View {
    let movieWithGenres: MovieWithGenres
    @State private var currentScale: CGFloat = 1.0

    var body: some View {
        let movie = movieWithGenres.movie
        let genres = movieWithGenres.genres
        
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                LazyImage(url: movie.posterURL) { state in
                    if let image = state.image {
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()
                            .scaleEffect(self.currentScale)
                            .animation(.easeInOut(duration: 10), value: self.currentScale)
                            .onAppear {
                                self.currentScale = CGFloat.random(in: 1.1...1.3)
                            }
                    } else {
                        SkeletonView(width: geometry.size.width,
                                     height: geometry.size.height)
                        .cornerRadius(8)
                    }
                }
                .overlay(
                    LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black.opacity(1)]), startPoint: .center, endPoint: .bottom)
                        .frame(height: geometry.size.height)
                        .opacity(1)
                )

                VStack(spacing: 5) {
                    Text(movie.title)
                        .font(.system(size: 26))
                        .bold()
                        .fontWeight(.regular)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    HStack(alignment: .center, spacing: 10) {
                        let genreText = genres.prefix(3).joined(separator: " · ")
                        Text(genreText)
                            .font(.system(size: 14)).bold()
                            .fontWeight(.regular)
                            .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                            .foregroundColor(.lightGray)
                    }
                    
                    HStack(alignment: .center, spacing: 5) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.orange)
                        
                        Text(String(format: "%.1f", movie.voteAverage))
                            .font(.system(size: 16))
                            .bold()
                            .fontWeight(.regular)
                            .foregroundColor(.white)
                        
                        Text("(\(movie.voteCount) reviews)")
                            .font(.system(size: 14))
                            .fontWeight(.regular)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.bottom, 45)
                .padding(.horizontal, 10)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .clipped()
        }
    }
}

private struct SkeletonForHomeView: View {
    let headerHeight: CGFloat
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                HeaderView(headerHeight: headerHeight)
                    .frame(height: headerHeight)
                    .padding(EdgeInsets(top: 20, leading: 10, bottom: 0, trailing: 10))
                
                HStack(spacing: 15) {
                    SkeletonButton()
                    SkeletonButton()
                }
                .padding(.top, 15)
                .padding(.horizontal, 15)
                
                LazyVStack(spacing: 10) {
                    ForEach(0..<1) { _ in
                        PlaylistRow()
                    }
                }
                .padding(.top, 20)
            }
            .background(Color.black)
        }
    }
    
    private struct HeaderView: View {
        let headerHeight: CGFloat

        var body: some View {
            ZStack(alignment: .bottom) {
                SkeletonView(width: .infinity,
                             height: headerHeight)
                
                VStack(spacing: 10) {
                    SkeletonView(width: 150, height: 26)
                    
                    HStack(alignment: .center, spacing: 10) {
                        SkeletonView(width: 60, height: 20)
                        SkeletonView(width: 60, height: 20)
                        SkeletonView(width: 60, height: 20)
                    }
                    
                    HStack(alignment: .center, spacing: 5) {
                        SkeletonView(width: 60, height: 20)
                        SkeletonView(width: 60, height: 20)
                    }
                }
                .padding(.bottom, 25)
                .padding(.horizontal, 10)
            }
        }
    }
    
    private struct SkeletonButton: View {
        var body: some View {
            SkeletonView(width: 170, height: 54)
                .cornerRadius(27)
        }
    }
    
    private struct PlaylistRow: View {
        var body: some View {
            VStack(spacing: 15) {
                HStack {
                    SkeletonView(width: 170, height: 20)
                        .padding(.trailing, 5)
                    Spacer()
                    SkeletonView(width: 40, height: 20)
                }
                .padding(.horizontal, 10)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 15) {
                        ForEach(0..<4) { _ in
                            SkeletonMovieCell()
                        }
                    }
                }
            }
            .padding(.top, 15)
            .padding(.bottom, 25)
            .padding(.horizontal, 10)
            .background(Color.darkGray)
            .cornerRadius(16)
        }
    }
    
    private struct SkeletonMovieCell: View {
        var body: some View {
            SkeletonView(width: UIScreen.main.bounds.width / 3,
                         height: UIScreen.main.bounds.width / 3 * 1.4)
        }
    }
}

