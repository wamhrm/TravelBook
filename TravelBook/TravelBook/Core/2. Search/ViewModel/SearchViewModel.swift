//
//  SearchViewModel.swift
//  TravelBook
//
//  Created by ddorsat on 04.01.2026.
//

import Foundation
import Combine
import SwiftUI

enum SearchRoutes: Hashable {
    case searchResults
    case searchResultsCellDetails(CellModel)
    case searchFeedCellDetails(CellModel)
    case categories
    case categoryCells(CategoryModel)
    case categoryCellDetails(CellModel)
}

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var searchRoutes: [SearchRoutes] = []
    @Published var searchText = ""
    @Published private(set) var searchResults: [CellModel] = []
    @Published private(set) var categoryResults: [CellModel] = []
    @Published private(set) var selectedCategory: Categories? = nil
    @Published private(set) var cells: [CellModel] = []
    @Published private(set) var categories: [CategoryModel] = []
    @Published private(set) var canLoadMore = false

    private let contentService: any ContentServiceProtocol

    private var cancellables = Set<AnyCancellable>()

    var displayCells: [CellModel] {
        !cells.isEmpty ? cells : CellModel.mockArray
    }

    var displayCategories: [CategoryModel] {
        !categories.isEmpty ? categories : CategoryModel.mockArray
    }

    var displayCategoryResults: [CellModel] {
        return !categoryResults.isEmpty ? categoryResults : CellModel.mockArray
    }

    var popularRequests: [String] {
        return ["Храмы", "Лучшие суши", "Как обмануть джетлаг",
                "Кофе в Италии", "Винные дороги"]
    }

    init(contentService: any ContentServiceProtocol) {
        self.contentService = contentService
        self.cells = contentService.searchCells.value
        self.categories = contentService.allCategories.value

        setupSubscriptions()
    }

    deinit {
        cancellables.removeAll()
    }

    private func setupSubscriptions() {
        contentService.searchCells
            .receive(on: RunLoop.main)
            .assign(to: \.cells, on: self)
            .store(in: &cancellables)

        contentService.allCategories
            .receive(on: RunLoop.main)
            .assign(to: \.categories, on: self)
            .store(in: &cancellables)

        contentService.canLoadMoreSearch
            .receive(on: RunLoop.main)
            .assign(to: \.canLoadMore, on: self)
            .store(in: &cancellables)
    }

    func requestToSearch(_ request: String) {
        searchText = request
        Task { await searchData(searchTerm: request) }
    }

    func searchData(searchTerm: String? = nil) async {
        let term = (searchTerm ?? searchText).trimmingCharacters(in: .whitespacesAndNewlines)

        var urlComponents = URLComponents(string: "\(Constants.address)/search")
        var queryItems: [URLQueryItem] = []

        if !term.isEmpty {
            queryItems.append(URLQueryItem(name: "search", value: term))
            selectedCategory = nil
        }

        guard !queryItems.isEmpty else { return }

        urlComponents?.queryItems = queryItems

        guard let url = urlComponents?.url else { return }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }

            switch httpResponse.statusCode {
                case 200...299:
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let items = try decoder.decode([CellModel].self, from: data)

                    self.searchResults = items
                    if !term.isEmpty {
                        searchRoutes.append(.searchResults)
                    }
                case 401:
                    throw NetworkError.incorrentSignInCredentials
                case 409:
                    throw NetworkError.userAlreadyExists
                default:
                    throw NetworkError.apiError(message: "Status: \(httpResponse.statusCode)")
            }
        } catch {
            print("Ошибка поиска - \(error.localizedDescription)")
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
        Task { await contentService.fetchMoreSearchCells() }
    }

    func refreshData() {
        Task { await contentService.fetchData() }
    }
}

