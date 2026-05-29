//
//  FavoritesViewModel.swift
//  TravelBook
//
//  Created by ddorsat on 05.01.2026.
//

import Combine
import Foundation

enum FavoritesRoutes: Hashable {
    case cellDetails(CellModel)
}

@MainActor
final class FavoritesViewModel: ObservableObject {
    @Published var favoritesRoutes: [FavoritesRoutes] = []
    @Published private(set) var favoriteCells: [CellModel] = []
    
    @Published var showAlert = false
    @Published private(set) var alertMessage = ""

    let authService: any AuthServiceProtocol
    let favoritesService: any FavoritesServiceProtocol

    private var cancellables = Set<AnyCancellable>()
    
    var isSignedOut: Bool {
        return authService.authState.value == .signedOut
    }

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
                        Task { await self?.fetchFavorites() }
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

    func fetchFavorites() async {
        do {
            try await favoritesService.fetchFavorites()
        } catch {
            showAlert(message: error.localizedDescription)
        }
    }

    func removeFromFavorites(cell: CellModel) {
        Task {
            do {
                try await favoritesService.toggleFavorite(for: cell)
            } catch {
                showAlert(message: error.localizedDescription)
            }
        }
    }

    private func showAlert(message: String) {
        showAlert = true
        alertMessage = message
    }
}
