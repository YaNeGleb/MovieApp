//
//  DotIndicatorView.swift
//  MovieApp
//
//  Created by Zabroda Gleb on 26.08.2024.
//

import SwiftUI

struct DotIndicatorView: View {
    @Binding var selectedPage: Int
    var pages: Int
    
    var body: some View {
        HStack {
            ForEach(0 ..< pages, id: \.self) { index in
                Capsule()
                    .fill(blue(index == selectedPage ? 1 : 0.5))
                    .frame(width: index == selectedPage ? 25 : 10, height: 8)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.3), value: selectedPage)
            }
        }
        .padding()
    }
    
    private func blue(_ opacity: Double) -> Color {
        .gray.opacity(opacity)
    }
}
