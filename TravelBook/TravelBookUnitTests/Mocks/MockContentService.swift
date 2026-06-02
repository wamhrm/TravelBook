//
//  MockContentService.swift
//  TravelBookUnitTests
//
//  Created by ddorsat on 02.06.2026.
//

import Combine
import Foundation
@testable import TravelBook

@MainActor
final class MockContentService: ContentServiceProtocol {
    let feedCells = CurrentValueSubject<[CellModel], Never>([])
    let searchCells = CurrentValueSubject<[CellModel], Never>([])
    let popularCells = CurrentValueSubject<[CellModel], Never>([])
    let allCategories = CurrentValueSubject<[CategoryModel], Never>([])
    let canLoadMoreFeed = CurrentValueSubject<Bool, Never>(false)
    let canLoadMoreSearch = CurrentValueSubject<Bool, Never>(false)

    var searchResultsToReturn: [CellModel] = []
    var errorToThrow: Error?

    private(set) var fetchDataCallCount = 0
    private(set) var fetchMoreFeedCallCount = 0
    private(set) var fetchMoreSearchCallCount = 0
    private(set) var fetchSearchResultsCallCount = 0

    func fetchData() async throws {
        fetchDataCallCount += 1
        if let errorToThrow { throw errorToThrow }
    }

    func fetchMoreFeedCells() async throws {
        fetchMoreFeedCallCount += 1
        if let errorToThrow { throw errorToThrow }
    }

    func fetchSearchCells() async throws {
        if let errorToThrow { throw errorToThrow }
    }

    func fetchMoreSearchCells() async throws {
        fetchMoreSearchCallCount += 1
        if let errorToThrow { throw errorToThrow }
    }

    func fetchSearchResults(term: String) async throws -> [CellModel] {
        fetchSearchResultsCallCount += 1
        if let errorToThrow { throw errorToThrow }
        return searchResultsToReturn
    }
}
