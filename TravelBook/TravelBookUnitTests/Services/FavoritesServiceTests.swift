//
//  FavoritesServiceTests.swift
//  TravelBookUnitTests
//
//  Created by ddorsat on 02.06.2026.
//

import Combine
import XCTest
@testable import TravelBook

@MainActor
final class FavoritesServiceTests: XCTestCase {
    func test_toggleFavorite_whenNotLiked_addsLocallyAndCallsNetwork() async throws {
        // Given
        let (sut, network) = makeSUT()
        let cell = CellModel.mock
        let id = try XCTUnwrap(cell.id)

        // When
        try await sut.toggleFavorite(for: cell)

        // Then
        XCTAssertTrue(sut.favoriteCells.value.contains(cell))
        XCTAssertTrue(sut.likedIDs.value.contains(id))
        XCTAssertEqual(network.addFavoriteCallCount, 1)
    }

    func test_toggleFavorite_whenNetworkFails_rollsBackLocalState() async {
        // Given
        let (sut, network) = makeSUT()
        network.errorToThrow = MockError.notStubbed

        // When
        try? await sut.toggleFavorite(for: .mock)

        // Then
        XCTAssertTrue(sut.favoriteCells.value.isEmpty)
        XCTAssertTrue(sut.likedIDs.value.isEmpty)
    }

    func test_clearFavorites_emptiesState() async throws {
        // Given
        let (sut, _) = makeSUT()
        try await sut.toggleFavorite(for: .mock)

        // When
        sut.clearFavorites()

        // Then
        XCTAssertTrue(sut.favoriteCells.value.isEmpty)
        XCTAssertTrue(sut.likedIDs.value.isEmpty)
    }

    func test_fetchFavorites_whenSignedIn_loadsFromNetwork() async throws {
        // Given
        let (sut, network) = makeSUT(authState: .signedIn(.mock))
        network.favoritesToReturn = [.mock]

        // When
        try await sut.fetchFavorites()

        // Then
        XCTAssertEqual(sut.favoriteCells.value.count, 1)
    }

    func test_fetchFavorites_whenSignedOut_doesNothing() async throws {
        // Given
        let (sut, network) = makeSUT(authState: .signedOut)
        network.favoritesToReturn = [.mock]

        // When
        try await sut.fetchFavorites()

        // Then
        XCTAssertTrue(sut.favoriteCells.value.isEmpty)
    }
    
    // MARK: - Helpers
    private func makeSUT(authState: AuthState = .signedOut)
        -> (sut: FavoritesService, network: MockNetworkService) {
        let network = MockNetworkService()
        let sut = FavoritesService(authService: MockAuthService(state: authState),
                                   networkService: network)
        return (sut, network)
    }
}
