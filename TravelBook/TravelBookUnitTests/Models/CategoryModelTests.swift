//
//  CategoryModelTests.swift
//  TravelBookUnitTests
//
//  Created by ddorsat on 02.06.2026.
//

import XCTest
@testable import TravelBook

@MainActor
final class CategoryModelTests: XCTestCase {
    func test_init_withoutCells_defaultsToEmpty() {
        // Given / When
        let category = CategoryModel(id: UUID(), title: "Заграница", type: .abroad, image: "")

        // Then
        XCTAssertTrue(category.cells.isEmpty)
    }

    func test_init_withCells_keepsCells() {
        // Given / When
        let category = CategoryModel(id: UUID(), title: "Заграница", type: .abroad, image: "", cells: [.mock])

        // Then
        XCTAssertEqual(category.cells.count, 1)
    }
}
