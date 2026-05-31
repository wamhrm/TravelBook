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
    @StateObject private var contentService: ContentService
    @StateObject private var favoritesService: FavoritesService
    @AppStorage(Constants.selectedThemeKey) private var selectedTheme: AppTheme = .system

    init() {
        let keychain = KeychainHelper()
        let networkService = NetworkService(keychain: keychain)
        let authService = AuthService(networkService: networkService, keychain: keychain)

        _authService = StateObject(wrappedValue: authService)
        _contentService = StateObject(wrappedValue: ContentService(networkService: networkService))
        _favoritesService = StateObject(wrappedValue: FavoritesService(authService: authService,
                                                                       networkService: networkService))
    }

    var body: some Scene {
        WindowGroup {
            MainTabView(authService: authService,
                        contentService: contentService,
                        favoritesService: favoritesService)
                .preferredColorScheme(selectedTheme.colorScheme)
        }
    }
}
