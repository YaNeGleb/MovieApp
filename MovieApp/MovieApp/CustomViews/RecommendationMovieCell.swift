//
//  RecommendationMovieCell.swift
//  MovieApp
//
//  Created by Zabroda Gleb on 26.08.2024.
//

import SwiftUI
import NukeUI

struct RecommendationMovieCell: View {
    let movie: Movie
    let width: CGFloat
    let height: CGFloat
    
    @State private var isImageLoaded = false
    
    var body: some View {
        VStack(alignment: .center) {
            LazyImage(url: movie.posterURL) { state in
                ZStack {
                    if let image = state.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: width, height: height)
                            .cornerRadius(10)
                            .clipped()
                            .opacity(isImageLoaded ? 1.0 : 0.0)
                            .animation(.easeInOut(duration: 0.5), value: isImageLoaded)
                            .onAppear {
                                isImageLoaded = true
                            }
                    } else {
                        SkeletonView(width: width, height: height)
                            .cornerRadius(10)
                    }
                }
            }
            
            Text(movie.title)
                .font(.system(size: 14)).bold()
                .fontWeight(.regular)
                .foregroundColor(.white)
                .padding(.top, 4)
                .frame(width: width)
                .lineLimit(1)
        }
    }
}

