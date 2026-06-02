//
//  MockNetworkService.swift
//  TravelBookUnitTests
//
//  Created by ddorsat on 02.06.2026.
//

import Foundation
@testable import TravelBook

@MainActor
final class MockNetworkService: NetworkServiceProtocol {
    var authTokenResponse = AuthTokenResponse(token: "test-token", user: .mock)
    var favoritesToReturn: [CellModel] = []
    var cellsToReturn: [CellModel] = []
    var popularToReturn: [CellModel] = []
    var categoriesToReturn: [CategoryModel] = []
    var searchResultsToReturn: [CellModel] = []
    var errorToThrow: Error?

    private(set) var createAccountCallCount = 0
    private(set) var signInCallCount = 0
    private(set) var addFavoriteCallCount = 0
    private(set) var removeFavoriteCallCount = 0

    func createAccount(name: String, email: String, password: String) async throws {
        createAccountCallCount += 1
        if let errorToThrow { throw errorToThrow }
    }

    func signIn(email: String, password: String) async throws -> AuthTokenResponse {
        signInCallCount += 1
        if let errorToThrow { throw errorToThrow }
        return authTokenResponse
    }

    func fetchFavorites() async throws -> [CellModel] {
        if let errorToThrow { throw errorToThrow }
        return favoritesToReturn
    }

    func addFavorite(id: UUID) async throws {
        addFavoriteCallCount += 1
        if let errorToThrow { throw errorToThrow }
    }

    func removeFavorite(id: UUID) async throws {
        removeFavoriteCallCount += 1
        if let errorToThrow { throw errorToThrow }
    }

    func fetchCells(page: Int, limit: Int, seed: String) async throws -> [CellModel] {
        if let errorToThrow { throw errorToThrow }
        return cellsToReturn
    }

    func fetchPopularCells() async throws -> [CellModel] {
        if let errorToThrow { throw errorToThrow }
        return popularToReturn
    }

    func fetchCategories() async throws -> [CategoryModel] {
        if let errorToThrow { throw errorToThrow }
        return categoriesToReturn
    }

    func fetchSearchResults(term: String) async throws -> [CellModel] {
        if let errorToThrow { throw errorToThrow }
        return searchResultsToReturn
    }
}
