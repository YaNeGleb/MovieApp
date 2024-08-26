//
//  LoaderDotView.swift
//  MovieApp
//
//  Created by Zabroda Gleb on 26.08.2024.
//

import SwiftUI

struct LoaderDotView: View {
    var body: some View {
        HStack {
            DotView()
            DotView(delay: 0.2)
            DotView(delay: 0.4)
        }
    }
}

struct DotView: View {
    @State var delay: Double = 0
    @State var scale: CGFloat = 0.5
    
    var body: some View {
        Circle()
            .frame(width: 15, height: 15)
            .scaleEffect(scale)
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 0.6).repeatForever().delay(delay)) {
                    self.scale = 1
                }
            }
    }
}
