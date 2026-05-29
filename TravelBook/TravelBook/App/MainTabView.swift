//
//  MainTabView.swift
//  MainTabView
//
//  Created by ddorsat on 01.01.2026.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var feedViewModel: FeedViewModel
    @StateObject private var searchViewModel: SearchViewModel
    @StateObject private var favoritesViewModel: FavoritesViewModel
    @StateObject private var profileViewModel: ProfileViewModel

    @State private var selectedTab: Tabs = .feed
    
    private let authService: AuthService
    private let favoritesService: FavoritesService

    init(authService: AuthService,
         contentService: ContentService,
         favoritesService: FavoritesService) {
        self.authService = authService
        self.favoritesService = favoritesService

        _feedViewModel = StateObject(wrappedValue: FeedViewModel(
            contentService: contentService,
            favoritesService: favoritesService))
        _searchViewModel = StateObject(wrappedValue: SearchViewModel(
            contentService: contentService))
        _favoritesViewModel = StateObject(wrappedValue: FavoritesViewModel(
            authService: authService,
            favoritesService: favoritesService))
        _profileViewModel = StateObject(wrappedValue: ProfileViewModel(
            authService: authService))
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab(value: .feed, role: .none) {
                FeedView(vm: feedViewModel,
                         authService: authService,
                         favoritesService: favoritesService)
            } label: {
                Image(systemName: Tabs.feed.icon)
            }

            Tab(value: .search, role: .none) {
                SearchView(vm: searchViewModel,
                           authService: authService,
                           favoritesService: favoritesService)
            } label: {
                Image(systemName: Tabs.search.icon)
            }

            Tab(value: .favorites, role: .none) {
                FavoritesView(vm: favoritesViewModel)
            } label: {
                Image(systemName: Tabs.favorites.icon)
            }

            Tab(value: .profile, role: .none) {
                ProfileView(vm: profileViewModel)
            } label: {
                Image(systemName: Tabs.profile.icon)
            }
        }
        .disabled(feedViewModel.feedCells.isEmpty)
        .tabBarMinimizeBehavior(.never)
    }
}

fileprivate enum Tabs {
    case feed, search, favorites, profile

    var icon: String {
        switch self {
            case .feed:
                return "airplane.up.right"
            case .search:
                return "magnifyingglass"
            case .favorites:
                return "heart"
            case .profile:
                return "person"
        }
    }
}

#Preview {
    let authService = AuthService()
    let contentService = ContentService()
    let favoritesService = FavoritesService(authService: authService)

    return MainTabView(authService: authService,
                       contentService: contentService,
                       favoritesService: favoritesService)
}
