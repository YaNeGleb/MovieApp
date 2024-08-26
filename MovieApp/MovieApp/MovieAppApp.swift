//
//  MovieAppApp.swift
//  MovieApp
//
//  Created by Zabroda Gleb on 26.08.2024.
//

import SwiftUI
import ComposableArchitecture

@main
struct MovieAppApp: App {
    let store = Store(initialState: HomeFeature.State()) {
        HomeFeature()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView(store: store)
        }
    }
}
