//
//  SearchViewModelTests.swift
//  TravelBookUnitTests
//
//  Created by ddorsat on 02.06.2026.
//

import Combine
import XCTest
@testable import TravelBook

@MainActor
final class SearchViewModelTests: XCTestCase {
    func test_selectCategory_setsResultsFromMatchingCategory() {
        // Given
        let content = MockContentService()
        let category = CategoryModel(id: UUID(), title: "Заграница", type: .abroad, image: "", cells: [.mock])
        content.allCategories.send([category])
        let sut = SearchViewModel(contentService: content)

        // When
        sut.selectCategory(.abroad)

        // Then
        XCTAssertEqual(sut.selectedCategory, .abroad)
        XCTAssertEqual(sut.categoryResults.count, 1)
        XCTAssertEqual(sut.searchText, "")
    }

    func test_searchData_whenTermEmpty_doesNothing() async {
        // Given
        let content = MockContentService()
        let sut = SearchViewModel(contentService: content)

        // When
        await sut.searchData(searchTerm: "   ")

        // Then
        XCTAssertTrue(sut.searchResults.isEmpty)
        XCTAssertFalse(sut.searchRoutes.contains(.searchResults))
        XCTAssertEqual(content.fetchSearchResultsCallCount, 0)
    }

    func test_searchData_whenTermValid_setsResultsAndAppendsRoute() async {
        // Given
        let content = MockContentService()
        content.searchResultsToReturn = [.mock]
        let sut = SearchViewModel(contentService: content)

        // When
        await sut.searchData(searchTerm: "Бали")

        // Then
        XCTAssertEqual(sut.searchResults.count, 1)
        XCTAssertTrue(sut.searchRoutes.contains(.searchResults))
        XCTAssertEqual(content.fetchSearchResultsCallCount, 1)
    }

    func test_requestToSearch_setsSearchTextAndLoadsResults() async {
        // Given
        let content = MockContentService()
        content.searchResultsToReturn = [.mock]
        let sut = SearchViewModel(contentService: content)

        // When
        sut.requestToSearch("Храмы")
        await waitUntil { !sut.searchResults.isEmpty }

        // Then
        XCTAssertEqual(sut.searchText, "Храмы")
        XCTAssertEqual(sut.searchResults.count, 1)
    }
}
