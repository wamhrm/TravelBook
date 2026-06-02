//
//  MockFavoritesService.swift
//  TravelBookUnitTests
//
//  Created by ddorsat on 02.06.2026.
//

import Combine
import Foundation
@testable import TravelBook

@MainActor
final class MockFavoritesService: FavoritesServiceProtocol {
    let favoriteCells = CurrentValueSubject<[CellModel], Never>([])
    let likedIDs = CurrentValueSubject<Set<UUID>, Never>([])

    var errorToThrow: Error?

    private(set) var fetchFavoritesCallCount = 0
    private(set) var toggleFavoriteCallCount = 0
    private(set) var clearFavoritesCallCount = 0
    private(set) var lastToggledCell: CellModel?

    func fetchFavorites() async throws {
        fetchFavoritesCallCount += 1
        if let errorToThrow { throw errorToThrow }
    }

    func toggleFavorite(for cell: CellModel) async throws {
        toggleFavoriteCallCount += 1
        lastToggledCell = cell
        if let errorToThrow { throw errorToThrow }
    }

    func clearFavorites() {
        clearFavoritesCallCount += 1
    }
}
