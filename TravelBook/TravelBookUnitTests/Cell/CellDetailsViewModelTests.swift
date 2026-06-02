//
//  CellDetailsViewModelTests.swift
//  TravelBookUnitTests
//
//  Created by ddorsat on 02.06.2026.
//

import Combine
import XCTest
@testable import TravelBook

@MainActor
final class CellDetailsViewModelTests: XCTestCase {
    func test_isFavorite_reflectsLikedIDs() async throws {
        // Given
        let cell = CellModel.mock
        let id = try XCTUnwrap(cell.id)
        let (sut, favorites) = makeSUT(cell: cell)

        // When
        favorites.likedIDs.send([id])
        await waitUntil { sut.isFavorite }

        // Then
        XCTAssertTrue(sut.isFavorite)
    }

    func test_toggleFavorite_callsService() async {
        // Given
        let (sut, favorites) = makeSUT(cell: .mock)

        // When
        sut.toggleFavorite()
        await waitUntil { favorites.toggleFavoriteCallCount == 1 }

        // Then
        XCTAssertEqual(favorites.toggleFavoriteCallCount, 1)
    }
    
    // MARK: - Helpers
    private func makeSUT(cell: CellModel)
        -> (sut: CellDetailsViewModel, favorites: MockFavoritesService) {
        let favorites = MockFavoritesService()
        let sut = CellDetailsViewModel(cell: cell,
                                       authService: MockAuthService(),
                                       favoritesService: favorites)
        return (sut, favorites)
    }
}
