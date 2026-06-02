//
//  FeedViewModelTests.swift
//  TravelBookUnitTests
//
//  Created by ddorsat on 02.06.2026.
//

import Combine
import XCTest
@testable import TravelBook

@MainActor
final class FeedViewModelTests: XCTestCase {
    func test_feedCellsSubscription_setsHeadCell() async {
        // Given
        let (sut, content) = makeSUT()

        // When
        content.feedCells.send([.mock])
        await waitUntil { sut.headCell != nil }

        // Then
        XCTAssertEqual(sut.feedCells.count, 1)
        XCTAssertEqual(sut.headCell, .mock)
    }

    func test_popularCellsSubscription_updatesPublishedCells() async {
        // Given
        let (sut, content) = makeSUT()

        // When
        content.popularCells.send([.mock])
        await waitUntil { !sut.popularCells.isEmpty }

        // Then
        XCTAssertEqual(sut.popularCells.count, 1)
    }

    func test_canLoadMoreSubscription_updatesFlag() async {
        // Given
        let (sut, content) = makeSUT()

        // When
        content.canLoadMoreFeed.send(true)
        await waitUntil { sut.canLoadMore }

        // Then
        XCTAssertTrue(sut.canLoadMore)
    }

    func test_fetchMoreCells_callsService() async {
        // Given
        let (sut, content) = makeSUT()

        // When
        sut.fetchMoreCells()
        await waitUntil { content.fetchMoreFeedCallCount == 1 }

        // Then
        XCTAssertEqual(content.fetchMoreFeedCallCount, 1)
    }
    
    // MARK: - Helpers
    private func makeSUT() -> (sut: FeedViewModel, content: MockContentService) {
        let content = MockContentService()
        let sut = FeedViewModel(contentService: content, favoritesService: MockFavoritesService())
        return (sut, content)
    }
}
