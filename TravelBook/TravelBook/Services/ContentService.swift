//
//  ContentService.swift
//  TravelBook
//
//  Created by ddorsat on 13.01.2026.
//

import Foundation
import Combine

protocol ContentServiceProtocol: ObservableObject {
    var feedCells: CurrentValueSubject<[CellModel], Never> { get }
    var searchCells: CurrentValueSubject<[CellModel], Never> { get }
    var popularCells: CurrentValueSubject<[CellModel], Never> { get }
    var allCategories: CurrentValueSubject<[CategoryModel], Never> { get }

    var canLoadMoreFeed: CurrentValueSubject<Bool, Never> { get }
    var canLoadMoreSearch: CurrentValueSubject<Bool, Never> { get }

    func fetchData() async throws
    func fetchMoreFeedCells() async throws
    func fetchSearchCells() async throws
    func fetchMoreSearchCells() async throws
    func fetchSearchResults(term: String) async throws -> [CellModel]
}

final class ContentService: ContentServiceProtocol {
    private let feed = PaginatedCells()
    private let search = PaginatedCells()

    let popularCells = CurrentValueSubject<[CellModel], Never>([])
    let allCategories = CurrentValueSubject<[CategoryModel], Never>([])

    var feedCells: CurrentValueSubject<[CellModel], Never> { feed.cells }
    var searchCells: CurrentValueSubject<[CellModel], Never> { search.cells }
    var canLoadMoreFeed: CurrentValueSubject<Bool, Never> { feed.canLoadMore }
    var canLoadMoreSearch: CurrentValueSubject<Bool, Never> { search.canLoadMore }

    private let limit = 6
    private var refreshFailure: ContentServiceErrors?

    private let networkService: any NetworkServiceProtocol

    init(networkService: any NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func fetchData() async throws {
        refreshFailure = nil
        feed.canLoadMore.send(false)
        search.canLoadMore.send(false)

        await Task {
            await withTaskGroup(of: Void.self) { group in
                group.addTask { await self.refreshFeedAndPopular() }
                group.addTask { await self.refreshSearch() }
                group.addTask { await self.refreshCategories() }
                await group.waitForAll()
            }
        }.value

        if let refreshFailure {
            throw refreshFailure
        }
    }

    func fetchMoreFeedCells() async throws {
        guard feed.canLoadMore.value, !feed.isLoading else { return }
        try await loadMore(feed)
    }

    func fetchSearchCells() async throws {
        try await loadPage(into: search, refreshing: true)
    }

    func fetchMoreSearchCells() async throws {
        guard search.canLoadMore.value, !search.isLoading else { return }
        try await loadMore(search)
    }

    func fetchSearchResults(term: String) async throws -> [CellModel] {
        try await networkService.fetchSearchResults(term: term)
    }

    private func refreshFeedAndPopular() async {
        feed.startRefresh()

        do {
            async let cellsResult = networkService.fetchCells(page: feed.page, limit: limit, seed: feed.seed)
            async let popularResult = networkService.fetchPopularCells()
            let (newCells, newPopular) = try await (cellsResult, popularResult)

            feed.cells.send(newCells)
            popularCells.send(newPopular.shuffled())
            feed.finishSuccess(newCount: newCells.count, limit: limit)
        } catch {
            feed.reset(clearCanLoadMore: !isCancellation(error))
            recordFailure(error, fallback: .failedToFetchFeedAndPopularCells)
        }
    }

    private func refreshSearch() async {
        do {
            try await loadPage(into: search, refreshing: true)
        } catch {
            recordFailure(error, fallback: .failedToFetchCells)
        }
    }

    private func refreshCategories() async {
        do {
            allCategories.send(try await networkService.fetchCategories())
        } catch {
            recordFailure(error, fallback: .failedToFetchCategories)
        }
    }

    private func loadMore(_ stream: PaginatedCells) async throws {
        do {
            try await loadPage(into: stream, refreshing: false)
        } catch {
            if isCancellation(error) { return }
            throw ContentServiceErrors.failedToFetchCells
        }
    }

    private func loadPage(into stream: PaginatedCells, refreshing: Bool) async throws {
        if refreshing {
            stream.startRefresh()
        } else {
            stream.isLoading = true
        }

        do {
            let newCells = try await networkService.fetchCells(page: stream.page, limit: limit, seed: stream.seed)
            stream.cells.send(refreshing ? newCells : stream.cells.value + newCells)
            stream.finishSuccess(newCount: newCells.count, limit: limit)
        } catch {
            stream.reset(clearCanLoadMore: !isCancellation(error))
            throw error
        }
    }

    private func recordFailure(_ error: Error, fallback: ContentServiceErrors) {
        guard !isCancellation(error), refreshFailure == nil else { return }
        refreshFailure = fallback
    }

    private func isCancellation(_ error: Error) -> Bool {
        error is CancellationError || Task.isCancelled
    }
}

private final class PaginatedCells {
    let cells = CurrentValueSubject<[CellModel], Never>([])
    let canLoadMore = CurrentValueSubject<Bool, Never>(false)

    private(set) var page = 1
    private(set) var seed = UUID().uuidString
    var isLoading = false

    func startRefresh() {
        page = 1
        seed = UUID().uuidString
        isLoading = true
    }

    func finishSuccess(newCount: Int, limit: Int) {
        let hasMore = newCount == limit
        canLoadMore.send(hasMore)
        if hasMore { page += 1 }
        isLoading = false
    }

    func reset(clearCanLoadMore: Bool) {
        isLoading = false
        if clearCanLoadMore { canLoadMore.send(false) }
    }
}

enum ContentServiceErrors: LocalizedError {
    case failedToFetchFeedAndPopularCells
    case failedToFetchCells
    case failedToFetchCategories

    var errorDescription: String? {
        switch self {
            case .failedToFetchFeedAndPopularCells:
                return "Ошибка загрузки основных и популярных ячеек"
            case .failedToFetchCells:
                return "Ошибка загрузки основных ячеек"
            case .failedToFetchCategories:
                return "Ошибка загрузки категорий"
        }
    }
}
