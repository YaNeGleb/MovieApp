//
//  StretchableImage.swift
//  MovieApp
//
//  Created by Zabroda Gleb on 26.08.2024.
//

import SwiftUI

struct StretchableImage: View {
    var image: Image
    var initialHeaderHeight: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            let minY = geometry.frame(in: .global).minY
            
            image
                .resizable()
                .frame(height: initialHeaderHeight)
                .scaleEffect(minY > 0 ? 1.0 + minY / initialHeaderHeight : 1.0, anchor: .top)
                .offset(y: minY > 0 ? -minY : 0)
                .aspectRatio(2, contentMode: .fit)
        }
        .frame(height: initialHeaderHeight)
    }
}
