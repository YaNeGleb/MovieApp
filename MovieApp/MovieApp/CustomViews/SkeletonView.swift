//
//  SkeletonView.swift
//  MovieApp
//
//  Created by Zabroda Gleb on 26.08.2024.
//

import SwiftUI

struct SkeletonView: View {
    var width: Double
    var height: Double
    
    var body: some View {
        Rectangle()
            .frame(width: width, height: height)
            .skeleton(if: true, reloadModel: nil)
            .cornerRadius(10)
    }
}

struct SkeletonModifier: ViewModifier {
    @State private var isAnimating = false
    private let foreverAnimation = Animation.default.speed(0.25)
        .repeatForever(autoreverses: false)
    private let mode: Mode?
    private let cornerRadius: CGFloat

    init(mode: Mode?, cornerRadius: CGFloat) {
        self.mode = mode
        self.cornerRadius = cornerRadius
    }
    
    func body(content: Content) -> some View {
        content
            .opacity(mode == nil ? 1 : 0)
            .overlay(
                GeometryReader { geo in
                    let width = geo.size.width
                    let xOffset = isAnimating ? width : -width
                    skeletonIfNeeded(
                        gradientOffset: xOffset,
                        height: geo.size.height
                    )
                }
            )
            .animation(.default, value: mode)
    }
    
    private func skeletonIfNeeded(
        gradientOffset: CGFloat,
        height: CGFloat
    ) -> some View {
        ZStack {
            switch mode {
            case .loading:
                Color.gray.opacity(0.2)
                    .overlay(
                        Color.gray
                            .mask(
                                Rectangle()
                                    .fill(linearGradient)
                                    .offset(x: gradientOffset)
                            )
                            .animation(foreverAnimation, value: isAnimating)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                    .onAppear { isAnimating = true }
                    .onDisappear { isAnimating = false }
            case let .needReload(model):
                NeedReloadView(
                    isVertical: height >= 100,
                    message: model.message,
                    action: model.action
                )
            default: EmptyView()
            }
        }
    }
    
    private var linearGradient: LinearGradient {
        LinearGradient(
            gradient: .init(colors: [.clear, .gray, .clear]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

extension SkeletonModifier {
    struct NeedReloadView: View {
        private let isVertical: Bool
        private let message: String
        private let action: () -> Void

        init(
            isVertical: Bool,
            message: String,
            action: @escaping () -> Void
        ) {
            self.isVertical = isVertical
            self.message = message
            self.action = action
        }
        
        var body: some View {
            content
                .frame(maxHeight: .infinity)
                .padding(.horizontal)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.2))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.gray, lineWidth: 0.5)
                        )
                )
                .onTapGesture(perform: action)
        }
    }
}

extension SkeletonModifier.NeedReloadView {
    private var reloadIconView: some View {
        Image(systemName: "exclamationmark.icloud")
            .resizable()
            .scaledToFit()
            .frame(height: 24)
    }
    
    @ViewBuilder
    private var content: some View {
        if isVertical {
            VStack(spacing: 12) {
                reloadIconView
                Text(message)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
            }
        } else {
            HStack(spacing: 16) {
                Text(message)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                reloadIconView
            }
        }
    }
}

extension SkeletonModifier {
    enum Mode: Equatable {
        case loading
        case needReload(ReloadModel)
        
        struct ReloadModel: Equatable {
            static func == (
                lhs: SkeletonModifier.Mode.ReloadModel,
                rhs: SkeletonModifier.Mode.ReloadModel
            ) -> Bool {
                lhs.message == rhs.message
            }
            
            let message: String
            let action: () -> Void
            
            init(message: String, action: @escaping () -> Void) {
                self.message = message
                self.action = action
            }
        }
    }
}

extension View {
    func skeleton(
        if loading: Bool = true,
        reloadModel: SkeletonModifier.Mode.ReloadModel? = nil,
        cornerRadius: CGFloat = 16
    ) -> some View {
        var mode: SkeletonModifier.Mode?
        if let reloadModel {
            mode = .needReload(reloadModel)
        } else if loading {
            mode = .loading
        }
        return modifier(
            SkeletonModifier(mode: mode, cornerRadius: cornerRadius)
        )
    }
}

