//
//  FeedViewModel.swift
//  TravelBook
//
//  Created by ddorsat on 05.01.2026.
//

import Combine
import Foundation
import SwiftUI

enum FeedRoutes: Hashable {
    case headCell(CellModel)
    case popular
    case bigCell(CellModel)
    case feedCell(CellModel)
    case cellDetails(CellModel)
}

final class FeedViewModel: ObservableObject {
    @Published var feedRoutes: [FeedRoutes] = []
    
    @Published private(set) var feedCells: [CellModel] = []
    @Published private(set) var popularCells: [CellModel] = []
    @Published private(set) var headCell: CellModel?
    
    @Published private(set) var isFetchingMore = false
    @Published private(set) var canLoadMore = false
    @Published private(set) var isServerWakingUp = false
    @Published var showAlert = false
    @Published private(set) var alertMessage = ""

    private let contentService: any ContentServiceProtocol
    private let favoritesService: any FavoritesServiceProtocol

    private var cancellables = Set<AnyCancellable>()

    var displayHeadCell: CellModel {
        return headCell ?? CellModel.mock
    }

    var displayFeedCells: [CellModel] {
        return !feedCells.isEmpty ? feedCells : CellModel.mockArray
    }

    var displayPopularCells: [CellModel] {
        return !popularCells.isEmpty ? popularCells : CellModel.mockArray
    }

    init(contentService: any ContentServiceProtocol,
         favoritesService: any FavoritesServiceProtocol) {
        self.contentService = contentService
        self.favoritesService = favoritesService
        self.feedCells = contentService.feedCells.value
        self.popularCells = contentService.popularCells.value

        setupSubscriptions()

        Task { await fetchData() }
    }

    deinit {
        cancellables.removeAll()
    }

    private func setupSubscriptions() {
        contentService.feedCells
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newCells in
                guard let self else { return }

                self.feedCells = newCells
                fetchHeadCell(newCells)
            }
            .store(in: &cancellables)

        contentService.popularCells
            .receive(on: DispatchQueue.main)
            .assign(to: \.popularCells, on: self)
            .store(in: &cancellables)

        contentService.canLoadMoreFeed
            .receive(on: DispatchQueue.main)
            .assign(to: \.canLoadMore, on: self)
            .store(in: &cancellables)
    }

    func fetchData() async {
        let loadedTask = Task {
            try? await Task.sleep(for: .seconds(3))
            
            if !Task.isCancelled {
                await MainActor.run {
                    withAnimation {
                        self.isServerWakingUp = true
                    }
                }
            }
        }
        
        do {
            try await contentService.fetchData()
        } catch {
            showAlert(message: error.localizedDescription)
        }

        loadedTask.cancel()

        await MainActor.run {
            withAnimation {
                self.isServerWakingUp = false
            }
        }
    }

    func fetchMoreCells() {
        guard !isFetchingMore else { return }
        
        isFetchingMore = true
        
        Task {
            do {
                try await contentService.fetchMoreFeedCells()
            } catch {
                showAlert(message: error.localizedDescription)
            }
            
            await MainActor.run { isFetchingMore = false }
        }
    }

    private func showAlert(message: String) {
        showAlert = true
        alertMessage = message
    }
    
    private func fetchHeadCell(_ newCells: [CellModel]) {
        if headCell == nil && !newCells.isEmpty {
            headCell = newCells.first(where: { $0.isHeadCell }) ?? newCells.first!
        }
    }
}

