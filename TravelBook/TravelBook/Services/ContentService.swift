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
    var feedCells = CurrentValueSubject<[CellModel], Never>([])
    var searchCells = CurrentValueSubject<[CellModel], Never>([])
    var popularCells = CurrentValueSubject<[CellModel], Never>([])
    var allCategories = CurrentValueSubject<[CategoryModel], Never>([])

    var canLoadMoreFeed = CurrentValueSubject<Bool, Never>(false)
    var canLoadMoreSearch = CurrentValueSubject<Bool, Never>(false)

    private var isFeedLoading = false
    private var isSearchLoading = false

    private var currentFeedSeed = UUID().uuidString
    private var currentSearchSeed = UUID().uuidString

    private var limit = 6
    private var feedPage = 1
    private var searchPage = 1

    init() {}

    func fetchData() async throws {
        feedPage = 1
        canLoadMoreFeed.send(false)
        canLoadMoreSearch.send(false)

        try await withThrowingTaskGroup(of: Void.self) { group in
            group.addTask { try await self.refreshFeedAndPopularCells() }
            group.addTask { try await self.fetchSearchCells() }
            group.addTask { try await self.fetchCategories() }
            try await group.waitForAll()
        }
    }

    private func refreshFeedAndPopularCells() async throws {
        isFeedLoading = true
        feedPage = 1
        currentFeedSeed = UUID().uuidString
        let seed = currentFeedSeed
        let page = 1

        do {
            async let cellsResult = fetchFeedCells(page: page, seed: seed)
            async let popularResult = fetchPopularCells()

            let (newCells, newPopular) = try await (cellsResult, popularResult)
            let hasMore = newCells.count == limit

            await MainActor.run {
                self.feedCells.send(newCells)
                self.popularCells.send(newPopular)
                self.canLoadMoreFeed.send(hasMore)
                self.feedPage = hasMore ? page + 1 : page
                self.isFeedLoading = false
            }
        } catch {
            await MainActor.run {
                self.isFeedLoading = false
                self.canLoadMoreFeed.send(false)
            }
            throw ContentServiceErrors.failedToRefreshFeedAndPopularCells
        }
    }

    private func fetchFeedCells(page: Int, seed: String) async throws -> [CellModel] {
        try await NetworkHelper.fetchCells(page: page, limit: limit, seed: seed)
    }

    private func fetchPopularCells() async throws -> [CellModel] {
        let cells = try await NetworkHelper.fetchPopularCells()
        return cells.shuffled()
    }

    func fetchMoreFeedCells() async throws {
        guard canLoadMoreFeed.value, !isFeedLoading else { return }

        try await fetchCells(pagePath: \.feedPage,
                         loadingPath: \.isFeedLoading,
                         canLoadSubjectPath: \.canLoadMoreFeed,
                         cellsSubjectPath: \.feedCells,
                         isRefreshing: false)
    }

    func fetchSearchCells() async throws {
        try await fetchCells(pagePath: \.searchPage,
                         loadingPath: \.isSearchLoading,
                         canLoadSubjectPath: \.canLoadMoreSearch,
                         cellsSubjectPath: \.searchCells,
                         isRefreshing: true)
    }

    func fetchMoreSearchCells() async throws {
        guard canLoadMoreSearch.value, !isSearchLoading else { return }

        try await fetchCells(pagePath: \.searchPage,
                         loadingPath: \.isSearchLoading,
                         canLoadSubjectPath: \.canLoadMoreSearch,
                         cellsSubjectPath: \.searchCells,
                         isRefreshing: false)
    }

    private func fetchCells(pagePath: ReferenceWritableKeyPath<ContentService, Int>,
                            loadingPath: ReferenceWritableKeyPath<ContentService, Bool>,
                            canLoadSubjectPath: KeyPath<ContentService, CurrentValueSubject<Bool, Never>>,
                            cellsSubjectPath: KeyPath<ContentService, CurrentValueSubject<[CellModel], Never>>,
                            isRefreshing: Bool) async throws {
        if isRefreshing {
            self[keyPath: pagePath] = 1

            if pagePath == \.feedPage {
                self.currentFeedSeed = UUID().uuidString
            } else if pagePath == \.searchPage {
                self.currentSearchSeed = UUID().uuidString
            }
        }

        self[keyPath: loadingPath] = true

        let currentPage = self[keyPath: pagePath]
        let seed = (pagePath == \.feedPage) ? currentFeedSeed : currentSearchSeed

        do {
            let newCells = try await NetworkHelper.fetchCells(page: currentPage, limit: limit, seed: seed)

            await MainActor.run {
                let cellsSubject = self[keyPath: cellsSubjectPath]
                let canLoadSubject = self[keyPath: canLoadSubjectPath]

                if isRefreshing {
                    cellsSubject.send(newCells)
                } else {
                    var current = cellsSubject.value
                    current.append(contentsOf: newCells)
                    cellsSubject.send(current)
                }

                let hasMore = newCells.count == self.limit
                canLoadSubject.send(hasMore)

                if hasMore {
                    self[keyPath: pagePath] += 1
                }

                self[keyPath: loadingPath] = false
            }
        } catch {
            await MainActor.run {
                self[keyPath: loadingPath] = false
                self[keyPath: canLoadSubjectPath].send(false)
            }
            throw ContentServiceErrors.failedToFetchCells
        }
    }

    private func fetchCategories() async throws {
        do {
            let loadedCategories = try await NetworkHelper.fetchCategories()
            await MainActor.run { self.allCategories.send(loadedCategories) }
        } catch {
            throw ContentServiceErrors.failedToFetchCategories
        }
    }

    func fetchSearchResults(term: String) async throws -> [CellModel] {
        try await NetworkHelper.fetchSearchResults(term: term)
    }
}

enum ContentServiceErrors: LocalizedError {
    case failedToRefreshFeedAndPopularCells
    case failedToFetchCells
    case failedToFetchCategories
    
    var errorDescription: String? {
        switch self {
            case .failedToRefreshFeedAndPopularCells:
                return "Ошибка загрузки основных и популярных ячеек"
            case .failedToFetchCells:
                return "Ошибка загрузки основных ячеек"
            case .failedToFetchCategories:
                return "Ошибка загрузки категорий"
        }
    }
}
