//
//  FavoritesViewModel.swift
//  TravelBook
//
//  Created by ddorsat on 05.01.2026.
//

//
//  FavoritesViewModel.swift
//  TravelBook
//
//  Created by ddorsat on 05.01.2026.
//

import Foundation
import Combine

enum FavoritesRoutes: Hashable {
    case cellDetails(CellModel)
}

@MainActor
final class FavoritesViewModel: ObservableObject {
    @Published var favoritesRoutes: [FavoritesRoutes] = []
    @Published private(set) var favorites: [CellModel] = []
    
    let favoritesService: any FavoritesServiceProtocol
    private let authService: any AuthServiceProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init(authService: any AuthServiceProtocol,
         favoritesService: any FavoritesServiceProtocol) {
        self.authService = authService
        self.favoritesService = favoritesService
        self.favorites = favoritesService.favoritesItems.value
        
        setupSubscriptions()
    }

    private func setupSubscriptions() {
        authService.authState
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                switch state {
                    case .signedIn:
                        Task { await self?.favoritesService.fetchFavorites() }
                    case .signedOut:
                        self?.favoritesService.clearFavorites()
                }
            }
            .store(in: &cancellables)
            
        favoritesService.favoritesItems
            .receive(on: RunLoop.main)
            .assign(to: \.favorites, on: self)
            .store(in: &cancellables)
    }
    
    func handleFavoriteToggle(for cell: CellModel) {
        favoritesService.toggleFavorite(for: cell)
    }

    func removeFromFavorites(cell: CellModel) {
        favoritesService.toggleFavorite(for: cell)
    }

    func fetchFavorites() {
        Task { await favoritesService.fetchFavorites() }
    }
}
