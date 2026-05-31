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
final class FavoritesViewModel: ObservableObject, AlertPresentable {
    @Published var favoritesRoutes: [FavoritesRoutes] = []
    @Published private(set) var favoriteCells: [CellModel] = []

    @Published var showAlert = false
    @Published var alertMessage = ""

    let authService: any AuthServiceProtocol
    let favoritesService: any FavoritesServiceProtocol

    private var cancellables = Set<AnyCancellable>()

    var isSignedOut: Bool {
        authService.authState.value == .signedOut
    }

    init(authService: any AuthServiceProtocol,
         favoritesService: any FavoritesServiceProtocol) {
        self.authService = authService
        self.favoritesService = favoritesService
        self.favoriteCells = favoritesService.favoriteCells.value

        setupSubscriptions()
    }

    private func setupSubscriptions() {
        authService.authState
            .receive(on: DispatchQueue.main)
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
            .receive(on: DispatchQueue.main)
            .assign(to: \.favoriteCells, on: self)
            .store(in: &cancellables)
    }

    func fetchFavorites() async {
        do {
            try await favoritesService.fetchFavorites()
        } catch {
            presentAlert(error.localizedDescription)
        }
    }

    func removeFromFavorites(cell: CellModel) {
        Task {
            do {
                try await favoritesService.toggleFavorite(for: cell)
            } catch {
                presentAlert(error.localizedDescription)
            }
        }
    }
}
