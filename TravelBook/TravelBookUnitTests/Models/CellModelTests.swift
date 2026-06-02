//
//  CellModelTests.swift
//  TravelBookUnitTests
//
//  Created by ddorsat on 02.06.2026.
//

import XCTest
@testable import TravelBook

@MainActor
final class CellModelTests: XCTestCase {
    func test_isMock_whenImageEmpty_returnsTrue() {
        // Given
        let cell = CellModel.mock

        // When / Then
        XCTAssertTrue(cell.isMock)
    }

    func test_isMock_whenImagePresent_returnsFalse() {
        // Given
        let cell = CellModel(id: UUID(),
                             title: "t",
                             subtitle: "s",
                             description: "d",
                             category: .abroad,
                             date: Date(),
                             readingTime: 5,
                             image: "https://example.com/image.png",
                             images: [],
                             isPopular: false,
                             isHeadCell: false)

        // When / Then
        XCTAssertFalse(cell.isMock)
    }

    func test_mockArray_hasThreeCells() {
        // Given / When / Then
        XCTAssertEqual(CellModel.mockArray.count, 3)
    }
}
