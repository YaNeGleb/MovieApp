//
//  CreditRow.swift
//  MovieApp
//
//  Created by Zabroda Gleb on 26.08.2024.
//

import SwiftUI
import NukeUI

struct CreditRow: View {
    let cast: Cast
    let width: CGFloat
    let height: CGFloat
    
    @State private var isImageLoaded = false
    
    var body: some View {
        VStack(alignment: .center) {
            LazyImage(url: cast.profilePathURL) { state in
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
                    }
                }
            }
            .frame(width: width, height: height)
            
            VStack(alignment: .leading) {
                Text(cast.name)
                    .font(.headline)
                    .frame(width: width)
                    .lineLimit(1)
                    .foregroundStyle(.white)
                
                if let character = cast.character {
                    Text("\(character)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .frame(width: width)
                        .lineLimit(1)
                }
            }
            .padding(.top, 4)
        }
    }
}

