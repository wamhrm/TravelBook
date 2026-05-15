//
//  FeedViewModel.swift
//  TravelBook
//
//  Created by ddorsat on 05.01.2026.
//

import Foundation
import SwiftUI
import Combine

enum FeedRoutes: Hashable {
    case headCell(CellModel)
    case popular
    case bigCell(CellModel)
    case feedCell(CellModel)
    case cellDetails(CellModel)
}

final class FeedViewModel: ObservableObject {
    @Published var feedRoutes: [FeedRoutes] = []
    @Published private(set) var cells: [CellModel] = []
    @Published private(set) var popularCells: [CellModel] = []
    @Published private(set) var canLoadMore = false
    @Published private(set) var pinnedHeadCell: CellModel?
    @Published private(set) var isServerWakingUp = false

    private let contentService: any ContentServiceProtocol
    private let favoritesService: any FavoritesServiceProtocol

    private var cancellables = Set<AnyCancellable>()

    var displayHeadCell: CellModel {
        pinnedHeadCell ?? CellModel.mock
    }

    var displayFeedCells: [CellModel] {
        !cells.isEmpty ? cells : CellModel.mockArray
    }

    var displayPopularCells: [CellModel] {
        !popularCells.isEmpty ? popularCells : CellModel.mockArray
    }

    init(contentService: any ContentServiceProtocol,
         favoritesService: any FavoritesServiceProtocol) {
        self.contentService = contentService
        self.favoritesService = favoritesService

        self.cells = contentService.feedCells.value
        self.popularCells = contentService.popularCells.value

        setupSubscriptions()

        Task { await fetchData() }
    }

    deinit {
        cancellables.removeAll()
    }

    private func setupSubscriptions() {
        contentService.feedCells
            .receive(on: RunLoop.main)
            .sink { [weak self] newCells in
                guard let self else { return }

                self.cells = newCells

                if self.pinnedHeadCell == nil, !newCells.isEmpty {
                    self.pinnedHeadCell = newCells.first(where: { $0.isHeadCell }) ?? newCells.first
                }
            }
            .store(in: &cancellables)

        contentService.popularCells
            .receive(on: RunLoop.main)
            .assign(to: \.popularCells, on: self)
            .store(in: &cancellables)

        contentService.canLoadMoreFeed
            .receive(on: RunLoop.main)
            .assign(to: \.canLoadMore, on: self)
            .store(in: &cancellables)
    }

    func fetchData() async {
        let loadingTask = Task {
            try? await Task.sleep(for: .seconds(2))
            
            if !Task.isCancelled {
                await MainActor.run {
                    self.isServerWakingUp = true
                }
            }
        }
        
        await contentService.fetchData()
        
        loadingTask.cancel()
        
        await MainActor.run {
            self.isServerWakingUp = false
        }
        
        await favoritesService.fetchFavorites()
    }

    func fetchMoreCells() {
        Task { await contentService.fetchMoreFeedCells() }
    }
}

