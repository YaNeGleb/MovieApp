//
//  HeaderView.swift
//  MovieApp
//
//  Created by Zabroda Gleb on 26.08.2024.
//

import SwiftUI
import ComposableArchitecture

struct HeaderView: View {
    let safeArea: EdgeInsets
    let size: CGSize
    let title: String
    let animated: Bool
    let sizeToAnimated: CGFloat
    let onBackButtonPressed: (() -> Void)?
    
    init(
        safeArea: EdgeInsets,
        size: CGSize,
        title: String,
        animated: Bool,
        sizeToAnimated: CGFloat = 100,
        onBackButtonPressed: (() -> Void)? = nil
    ) {
        self.safeArea = safeArea
        self.size = size
        self.title = title
        self.animated = animated
        self.sizeToAnimated = sizeToAnimated
        self.onBackButtonPressed = onBackButtonPressed
    }
    
    var body: some View {
        GeometryReader { proxy in
            WithPerceptionTracking {
                HStack {
                    if let onBackButtonPressed = onBackButtonPressed {
                        Button(action: {
                            onBackButtonPressed()
                        }, label: {
                            Image(systemName: "arrow.left")
                                .font(.title3)
                                .foregroundStyle(.white)
                        })
                        .padding(.leading, 15)
                    } else {
                        Spacer().frame(width: 44)
                    }
                    
                    Spacer()
                    
                    if animated {
                        Text(title)
                            .font(.system(size: 19)).bold()
                            .fontWeight(.regular)
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .clipped()
                            .opacity(animated ? computeOpacity(proxy: proxy) : 1)
                    } else {
                        Text(title)
                            .font(.system(size: 19)).bold()
                            .fontWeight(.regular)
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .clipped()
                    }
                    
                    Spacer()
                    Spacer().frame(width: 44)
                }
                .padding(.top, safeArea.top + 10)
                .padding(.bottom, 15)
                .background {
                    Rectangle()
                        .fill(.black)
                        .opacity(animated ? computeOpacity(proxy: proxy) : 1)
                }
                .offset(y: animated ? -proxy.frame(in: .named("SCROLL")).minY : 0)
            }
        }
        .frame(height: 35)
    }
    
    private func computeOpacity(proxy: GeometryProxy) -> Double {
        let minY = proxy.frame(in: .named("SCROLL")).minY
        let height = sizeToAnimated
        let progress = minY / (height * (minY > 0 ? 0.5 : 0.8))
        return -progress > 1 ? min(1, (-progress - 1) * 2) : 0
    }
}



