//
//  TravelBookApp.swift
//  TravelBook
//
//  Created by ddorsat on 01.01.2026.
//

import SwiftUI

@main
struct TravelBookApp: App {
    @StateObject private var authService: AuthService
    @StateObject private var contentService = ContentService()
    @StateObject private var favoritesService: FavoritesService

    @AppStorage("selectedTheme") private var selectedTheme: AppTheme = .system

    init() {
        let authService = AuthService()
        _authService = StateObject(wrappedValue: authService)
        _favoritesService = StateObject(wrappedValue: FavoritesService(authService: authService))
    }

    var body: some Scene {
        WindowGroup {
            MainTabView(authService: authService,
                        contentService: contentService,
                        favoritesService: favoritesService)
                .environmentObject(authService)
                .environmentObject(contentService)
                .environmentObject(favoritesService)
                .preferredColorScheme(selectedTheme.colorScheme)
        }
    }
}
