//
//  StillFromMovieRow.swift
//  MovieApp
//
//  Created by Zabroda Gleb on 26.08.2024.
//

import SwiftUI
import NukeUI

struct StillFromMovieRow: View {
    let filePathURL: URL
    
    var body: some View {
        VStack(alignment: .center) {
            LazyImage(url: filePathURL) { state in
                ZStack {
                    if let image = state.image {
                        image.resizable().aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 100)
                            .cornerRadius(8)
                            .clipped()
                    } else {
                        SkeletonView(width: 150, height: 100)
                            .cornerRadius(8)
                    }
                }
            }
        }
    }
}
