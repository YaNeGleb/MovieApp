//
//  MovieRow.swift
//  MovieApp
//
//  Created by Zabroda Gleb on 26.08.2024.
//

import SwiftUI
import NukeUI

struct MovieRow: View {
    let movie: Movie
    let width: CGFloat
    let height: CGFloat
    
    @State private var isImageLoaded = false
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .bottomTrailing) {
                LazyImage(url: movie.posterURL) { state in
                    ZStack {
                        if let image = state.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: width, height: height)
                                .cornerRadius(18)
                                .clipped()
                                .opacity(isImageLoaded ? 1.0 : 0.0)
                                .animation(.easeInOut(duration: 0.1), value: isImageLoaded)
                                .onAppear {
                                    isImageLoaded = true
                                }
                        } else {
                            SkeletonView(width: width, height: height)
                                .cornerRadius(18)
                        }
                    }
                }
                LinearGradient(
                    gradient: Gradient(colors: [Color.clear, Color.black.opacity(1)]),
                    startPoint: .center,
                    endPoint: .bottomTrailing
                )
                .cornerRadius(18)
                
                HStack(spacing: 5) {
                    Image(systemName: "star.fill")
                        .imageScale(.small)
                        .foregroundColor(.orange)
                    
                    Text(String(format: "%.1f", movie.voteAverage))
                        .foregroundColor(.white)
                        .font(.system(size: 17)).bold()
                        .fontWeight(.regular)
                }
                .padding(.bottom, 8)
                .padding(.trailing, 8)
            }
            
            Text(movie.title)
                .font(.system(size: 16))
                .bold()
                .fontWeight(.regular)
                .foregroundColor(.white)
                .frame(width: width)
                .lineLimit(1)
        }
    }
}
