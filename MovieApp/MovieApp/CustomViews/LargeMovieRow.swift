//
//  LargeMovieRow.swift
//  MovieApp
//
//  Created by Zabroda Gleb on 26.08.2024.
//

import SwiftUI
import NukeUI

struct LargeMovieRow: View {
    let movie: Movie
    let width: CGFloat
    let height: CGFloat
    
    @State private var isImageLoaded = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            LazyImage(url: movie.backdropURL) { state in
                if let image = state.image {
                    image.resizable().aspectRatio(contentMode: .fill)
                        .frame(width: width, height: height)
                        .cornerRadius(24)
                        .clipped()
                        .opacity(isImageLoaded ? 1.0 : 0.0)
                        .animation(.easeInOut(duration: 0.1), value: isImageLoaded)
                        .onAppear {
                            isImageLoaded = true
                        }
                } else {
                    SkeletonView(width: width, height: height)
                        .cornerRadius(24)
                }
            }
            .overlay(
                LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black.opacity(1)]), startPoint: .center, endPoint: .bottom)
                    .frame(height: height)
                    .opacity(1)
                    .cornerRadius(24)
            )
                        
            HStack(alignment: .bottom) {
                    Text(movie.title)
                        .font(.system(size: 16)).bold()
                        .fontWeight(.regular)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.white)
                        .lineLimit(nil)
                        .padding(.horizontal, 15)
                    
                    Spacer()
                    
                HStack(spacing: 5) {
                    Image(systemName: "star.fill")
                        .imageScale(.small)
                        .foregroundColor(.orange)
                    
                    Text(String(format: "%.1f", movie.voteAverage))
                        .foregroundColor(.white)
                        .font(.system(size: 17)).bold()
                        .fontWeight(.regular)
                }
                    .padding(.trailing, 8)
                }
                .padding(.bottom, 25)
                .frame(width: width - 16)
        }
    }
}
