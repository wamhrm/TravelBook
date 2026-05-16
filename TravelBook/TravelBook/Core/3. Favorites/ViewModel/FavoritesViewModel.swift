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
    @Published private(set) var favoriteCells: [CellModel] = []

    private let authService: any AuthServiceProtocol
    private let favoritesService: any FavoritesServiceProtocol

    var cellDetailsAuthService: any AuthServiceProtocol { authService }
    var cellDetailsFavoritesService: any FavoritesServiceProtocol { favoritesService }

    private var cancellables = Set<AnyCancellable>()

    init(authService: any AuthServiceProtocol,
         favoritesService: any FavoritesServiceProtocol) {
        self.authService = authService
        self.favoritesService = favoritesService
        self.favoriteCells = favoritesService.favoriteCells.value

        setupSubscriptions()
    }
    
    deinit {
        cancellables.removeAll()
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

        favoritesService.favoriteCells
            .receive(on: RunLoop.main)
            .assign(to: \.favoriteCells, on: self)
            .store(in: &cancellables)
    }

    func fetchFavorites() {
        Task { await favoritesService.fetchFavorites() }
    }

    func removeFromFavorites(cell: CellModel) {
        favoritesService.toggleFavorite(for: cell)
    }
}
