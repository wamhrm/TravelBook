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
    
    func fetchFavorites() async
    func toggleFavorite(for cell: CellModel)
    func clearFavorites()
}

@MainActor
final class FavoritesService: FavoritesServiceProtocol {
    var favoriteCells = CurrentValueSubject<[CellModel], Never>([])
    var likedIDs = CurrentValueSubject<Set<UUID>, Never>([])
    
    private let authService: any AuthServiceProtocol
    private let baseURL = "\(Constants.address)/favorites"
    
    private var cancellables = Set<AnyCancellable>()

    init(authService: any AuthServiceProtocol) {
        self.authService = authService
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    func fetchFavorites() async {
        guard authService.authState.value != .signedOut else { return }

        do {
            let data = try await NetworkHelper.request(url: baseURL, method: "GET")
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let cells = try decoder.decode([CellModel].self, from: data)
            self.favoriteCells.send(cells)
            
            let ids = Set(cells.compactMap { $0.id })
            self.likedIDs.send(ids)
        } catch {
            print("Ошибка загрузки избранного: \(error)")
        }
    }
    
    func toggleFavorite(for cell: CellModel) {
        guard let id = cell.id else { return }
        
        let isCurrentlyLiked = likedIDs.value.contains(id)
        
        if isCurrentlyLiked {
            removeFromLocalState(id: id)
        } else {
            addToLocalState(cell: cell)
        }
        
        Task {
            do {
                if isCurrentlyLiked {
                    let url = "\(baseURL)/\(id.uuidString)"
                    let _ = try await NetworkHelper.request(url: url, method: "DELETE")
                } else {
                    let url = "\(baseURL)/\(id.uuidString)"
                    let _ = try await NetworkHelper.request(url: url, method: "POST")
                }
            } catch {
                print("Ошибка синхронизации лайка: \(error)")
                if isCurrentlyLiked {
                    addToLocalState(cell: cell)
                } else {
                    removeFromLocalState(id: id)
                }
            }
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
