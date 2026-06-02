//
//  UserModelTests.swift
//  TravelBookUnitTests
//
//  Created by ddorsat on 02.06.2026.
//

import XCTest
@testable import TravelBook

@MainActor
final class UserModelTests: XCTestCase {
    func test_equality_whenSameId_areEqual() {
        // Given
        let id = UUID()
        let first = UserModel(id: id, name: "Дмитрий", email: "a@b.com", dateRegistered: Date())
        let second = UserModel(id: id, name: "Другое имя", email: "other@b.com", dateRegistered: Date())

        // When / Then
        XCTAssertEqual(first, second)
    }

    func test_equality_whenDifferentId_areNotEqual() {
        // Given
        let first = UserModel(id: UUID(), name: "Дмитрий", email: "a@b.com", dateRegistered: Date())
        let second = UserModel(id: UUID(), name: "Дмитрий", email: "a@b.com", dateRegistered: Date())

        // When / Then
        XCTAssertNotEqual(first, second)
    }
}
