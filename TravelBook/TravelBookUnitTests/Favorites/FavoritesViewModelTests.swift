//
//  FavoritesViewModelTests.swift
//  TravelBookUnitTests
//
//  Created by ddorsat on 02.06.2026.
//

import Combine
import XCTest
@testable import TravelBook

@MainActor
final class FavoritesViewModelTests: XCTestCase {
    func test_isSignedOut_reflectsAuthState() {
        // Given / When
        let (signedOut, _, _) = makeSUT(authState: .signedOut)
        let (signedIn, _, _) = makeSUT(authState: .signedIn(.mock))

        // Then
        XCTAssertTrue(signedOut.isSignedOut)
        XCTAssertFalse(signedIn.isSignedOut)
    }

    func test_removeFromFavorites_callsToggleOnService() async {
        // Given
        let (sut, _, favorites) = makeSUT()

        // When
        sut.removeFromFavorites(cell: .mock)
        await waitUntil { favorites.toggleFavoriteCallCount == 1 }

        // Then
        XCTAssertEqual(favorites.toggleFavoriteCallCount, 1)
        XCTAssertEqual(favorites.lastToggledCell, .mock)
    }

    func test_fetchFavorites_callsService() async {
        // Given
        let (sut, _, favorites) = makeSUT()

        // When
        await sut.fetchFavorites()

        // Then
        XCTAssertEqual(favorites.fetchFavoritesCallCount, 1)
    }

    func test_favoriteCellsSubscription_updatesPublishedCells() async {
        // Given
        let (sut, _, favorites) = makeSUT()

        // When
        favorites.favoriteCells.send([.mock])
        await waitUntil { !sut.favoriteCells.isEmpty }

        // Then
        XCTAssertEqual(sut.favoriteCells.count, 1)
    }
    
    // MARK: - Helpers
    private func makeSUT(authState: AuthState = .signedOut)
        -> (sut: FavoritesViewModel, auth: MockAuthService, favorites: MockFavoritesService) {
        let auth = MockAuthService(state: authState)
        let favorites = MockFavoritesService()
        let sut = FavoritesViewModel(authService: auth, favoritesService: favorites)
        return (sut, auth, favorites)
    }
}
