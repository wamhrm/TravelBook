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

final class FeedViewModel: ObservableObject, AlertPresentable {
    @Published var feedRoutes: [FeedRoutes] = []

    @Published private(set) var feedCells: [CellModel] = []
    @Published private(set) var popularCells: [CellModel] = []
    @Published private(set) var headCell: CellModel?
    
    @Published private(set) var isFetchingMore = false
    @Published private(set) var canLoadMore = false
    @Published private(set) var isServerWakingUp = false
    @Published var showAlert = false
    @Published var alertMessage = ""

    private let contentService: any ContentServiceProtocol
    private let favoritesService: any FavoritesServiceProtocol

    private var cancellables = Set<AnyCancellable>()

    init(contentService: any ContentServiceProtocol,
         favoritesService: any FavoritesServiceProtocol) {
        self.contentService = contentService
        self.favoritesService = favoritesService
        self.feedCells = contentService.feedCells.value
        self.popularCells = contentService.popularCells.value

        setupSubscriptions()
        Task { await fetchData() }
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
            try? await Task.sleep(for: .seconds(4))

            if !Task.isCancelled {
                withAnimation { self.isServerWakingUp = true }
            }
        }

        do {
            try await contentService.fetchData()
        } catch {
            presentAlert(error.localizedDescription)
        }

        loadedTask.cancel()
        withAnimation { isServerWakingUp = false }
    }

    func fetchMoreCells() {
        guard !isFetchingMore else { return }

        isFetchingMore = true

        Task {
            do {
                try await contentService.fetchMoreFeedCells()
            } catch {
                presentAlert(error.localizedDescription)
            }

            isFetchingMore = false
        }
    }

    private func fetchHeadCell(_ newCells: [CellModel]) {
        if headCell == nil && !newCells.isEmpty {
            headCell = newCells.first(where: { $0.isHeadCell }) ?? newCells.first!
        }
    }
}

