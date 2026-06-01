//
//  FavoritesService.swift
//  TravelBook
//
//  Created by ddorsat on 09.01.2026.
//

import Foundation
import Combine

protocol FavoritesServiceProtocol: ObservableObject {
    var favoriteCells: CurrentValueSubject<[CellModel], Never> { get }
    var likedIDs: CurrentValueSubject<Set<UUID>, Never> { get }
    
    func fetchFavorites() async throws
    func toggleFavorite(for cell: CellModel) async throws
    func clearFavorites()
}

final class FavoritesService: FavoritesServiceProtocol {
    let favoriteCells = CurrentValueSubject<[CellModel], Never>([])
    let likedIDs = CurrentValueSubject<Set<UUID>, Never>([])

    private let authService: any AuthServiceProtocol
    private let networkService: any NetworkServiceProtocol

    init(authService: any AuthServiceProtocol,
         networkService: any NetworkServiceProtocol = NetworkService()) {
        self.authService = authService
        self.networkService = networkService
    }

    func fetchFavorites() async throws {
        guard authService.authState.value != .signedOut else { return }

        do {
            let cells = try await networkService.fetchFavorites()
            self.favoriteCells.send(cells)
            
            let ids = Set(cells.compactMap { $0.id })
            self.likedIDs.send(ids)
        } catch {
            throw FavoritesServiceError.failedToFetchFavorites
        }
    }
    
    func toggleFavorite(for cell: CellModel) async throws {
        guard let id = cell.id else { return }
        
        let isCurrentlyLiked = likedIDs.value.contains(id)
        
        if isCurrentlyLiked {
            removeFromLocalState(id: id)
        } else {
            addToLocalState(cell: cell)
        }
        
        do {
            if isCurrentlyLiked {
                try await networkService.removeFavorite(id: id)
            } else {
                try await networkService.addFavorite(id: id)
            }
        } catch {
            if isCurrentlyLiked {
                addToLocalState(cell: cell)
            } else {
                removeFromLocalState(id: id)
            }
            throw FavoritesServiceError.failedToToggle
        }
    }
    
    func clearFavorites() {
        favoriteCells.send([])
        likedIDs.send([])
    }
    
    private func addToLocalState(cell: CellModel) {
        guard let id = cell.id, !likedIDs.value.contains(id) else { return }

        favoriteCells.send(favoriteCells.value + [cell])
        likedIDs.send(likedIDs.value.union([id]))
    }
    
    private func removeFromLocalState(id: UUID) {
        guard likedIDs.value.contains(id) else { return }

        favoriteCells.send(favoriteCells.value.filter { $0.id != id })
        likedIDs.send(likedIDs.value.subtracting([id]))
    }
}

private enum FavoritesServiceError: LocalizedError {
    case failedToFetchFavorites
    case failedToToggle
    
    var errorDescription: String? {
        switch self {
            case .failedToFetchFavorites:
                return "Ошибка загрузки избранного"
            case .failedToToggle:
                return "Ошибка синхронизации лайка"
        }
    }
}
