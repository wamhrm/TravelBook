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

@MainActor
final class FavoritesService: FavoritesServiceProtocol {
    var favoriteCells = CurrentValueSubject<[CellModel], Never>([])
    var likedIDs = CurrentValueSubject<Set<UUID>, Never>([])
    
    private let authService: any AuthServiceProtocol
    private let networkService: any NetworkServiceProtocol

    private var cancellables = Set<AnyCancellable>()

    init(authService: any AuthServiceProtocol,
         networkService: any NetworkServiceProtocol = NetworkService()) {
        self.authService = authService
        self.networkService = networkService
    }
    
    deinit {
        cancellables.removeAll()
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
        var currentItems = favoriteCells.value
        var currentIDs = likedIDs.value
        
        if !currentIDs.contains(cell.id!) {
            currentItems.append(cell)
            currentIDs.insert(cell.id!)
            
            favoriteCells.send(currentItems)
            likedIDs.send(currentIDs)
        }
    }
    
    private func removeFromLocalState(id: UUID) {
        var currentItems = favoriteCells.value
        var currentIDs = likedIDs.value
        
        if currentIDs.contains(id) {
            currentItems.removeAll { $0.id == id }
            currentIDs.remove(id)
            
            favoriteCells.send(currentItems)
            likedIDs.send(currentIDs)
        }
    }
}

enum FavoritesServiceError: LocalizedError {
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
