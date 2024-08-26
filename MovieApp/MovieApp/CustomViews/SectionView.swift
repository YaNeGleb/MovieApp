//
//  SectionView.swift
//  MovieApp
//
//  Created by Zabroda Gleb on 26.08.2024.
//

import SwiftUI

struct SectionView<Content: View>: View {
    var title: String
    var showAllButton: Bool
    var content: Content
    let onAllButtonPressed: (() -> Void)?
    
    init(title: String,
         showAllButton: Bool = false,
         onAllButtonPressed: (() -> Void)? = nil,
         @ViewBuilder content: () -> Content) {
        self.title = title
        self.showAllButton = showAllButton
        self.onAllButtonPressed = onAllButtonPressed
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text(title)
                    .font(.system(size: 20)).bold()
                    .fontWeight(.regular)
                    .foregroundColor(.white)
                
                Spacer()
                
                if showAllButton, let onAllButtonPressed = onAllButtonPressed {
                    Button(action: {
                        onAllButtonPressed()
                    }) {
                        Text("All")
                            .font(.system(size: 16)).bold()
                            .fontWeight(.regular)
                            .padding(5)
                            .foregroundColor(Color.gray)
                    }
                }
            }
            
            content
                .padding(.top, 5)
        }
        .padding(.top, 15)
        .padding(.bottom, 25)
        .padding(.horizontal, 20)
        .background(Color.darkGray)
        .cornerRadius(10)
        .frame(maxWidth: .infinity)
    }
}

