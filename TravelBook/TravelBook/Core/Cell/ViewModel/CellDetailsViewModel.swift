//
//  CellDetailsViewModel.swift
//  TravelBook
//
//  Created by ddorsat on 09.01.2026.
//

import Foundation
import Combine

final class CellDetailsViewModel: ObservableObject {
    @Published var isFavorite = false
    @Published var showAuthAlert = false
    
    private let cell: CellModel
    private let favoritesService: any FavoritesServiceProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init(cell: CellModel,
         favoritesService: any FavoritesServiceProtocol) {
        self.cell = cell
        self.favoritesService = favoritesService
        
        setupSubscription()
    }
    
    private func setupSubscription() {
        guard let id = cell.id else { return }

        favoritesService.likedIDs
            .receive(on: DispatchQueue.main)
            .map { $0.contains(id) }
            .sink { [weak self] isLiked in
                self?.isFavorite = isLiked
            }
            .store(in: &cancellables)
    }
        
    func toggleFavorite() {
        Task {
            try? await favoritesService.toggleFavorite(for: cell)
        }
    }
}
