//
//  ContentServiceTests.swift
//  TravelBookUnitTests
//
//  Created by ddorsat on 02.06.2026.
//

import XCTest
@testable import TravelBook

@MainActor
final class ContentServiceTests: XCTestCase {
    func test_fetchSearchResults_forwardsNetworkResult() async throws {
        // Given
        let network = MockNetworkService()
        network.searchResultsToReturn = [.mock]
        let sut = ContentService(networkService: network)

        // When
        let result = try await sut.fetchSearchResults(term: "Бали")

        // Then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first, .mock)
    }
}
