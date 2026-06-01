//
//  SearchViewModel.swift
//  TravelBook
//
//  Created by ddorsat on 04.01.2026.
//

import Combine
import Foundation

enum SearchRoutes: Hashable {
    case searchResults
    case searchResultsCellDetails(CellModel)
    case searchFeedCellDetails(CellModel)
    case categories
    case categoryCells(CategoryModel)
    case categoryCellDetails(CellModel)
}

@MainActor
final class SearchViewModel: ObservableObject, AlertPresentable {
    @Published var searchRoutes: [SearchRoutes] = []
    
    @Published private(set) var cells: [CellModel] = []
    @Published private(set) var categories: [CategoryModel] = []
    @Published private(set) var selectedCategory: Categories? = nil
    @Published private(set) var categoryResults: [CellModel] = []
    
    @Published var searchText = ""
    @Published private(set) var searchResults: [CellModel] = []
    
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published private(set) var isFetchingMore = false
    @Published private(set) var canLoadMore = false

    private let contentService: any ContentServiceProtocol

    private var cancellables = Set<AnyCancellable>()

    var popularRequests: [String] {
        ["Храмы", "Лучшие суши", "Как обмануть джетлаг",
         "Кофе в Италии", "Винные дороги"]
    }

    init(contentService: any ContentServiceProtocol) {
        self.contentService = contentService
        self.cells = contentService.searchCells.value
        self.categories = contentService.allCategories.value

        setupSubscriptions()
    }

    private func setupSubscriptions() {
        contentService.searchCells
            .receive(on: DispatchQueue.main)
            .assign(to: \.cells, on: self)
            .store(in: &cancellables)

        contentService.allCategories
            .receive(on: DispatchQueue.main)
            .assign(to: \.categories, on: self)
            .store(in: &cancellables)

        contentService.canLoadMoreSearch
            .receive(on: DispatchQueue.main)
            .assign(to: \.canLoadMore, on: self)
            .store(in: &cancellables)
    }

    func requestToSearch(_ request: String) {
        searchText = request
        Task { await searchData(searchTerm: request) }
    }

    func searchData(searchTerm: String? = nil) async {
        let term = (searchTerm ?? searchText).trimmingCharacters(in: .whitespacesAndNewlines)
        guard !term.isEmpty else { return }

        selectedCategory = nil

        do {
            let items = try await contentService.fetchSearchResults(term: term)
            searchResults = items
            searchRoutes.append(.searchResults)
        } catch {
            presentAlert(error.localizedDescription)
        }
    }

    func selectCategory(_ category: Categories) {
        selectedCategory = category
        searchText = ""

        if let selectedCategory = categories.first(where: { $0.type == category }) {
            categoryResults = selectedCategory.cells
        } else {
            categoryResults = contentService.searchCells.value.filter { $0.category == category }
        }
    }

    func fetchMoreCells() {
        guard !isFetchingMore else { return }

        isFetchingMore = true

        Task {
            do {
                try await contentService.fetchMoreSearchCells()
            } catch {
                presentAlert(error.localizedDescription)
            }

            isFetchingMore = false
        }
    }

    func refreshData() {
        Task {
            do {
                try await contentService.fetchData()
            } catch {
                presentAlert(error.localizedDescription)
            }
        }
    }
}

