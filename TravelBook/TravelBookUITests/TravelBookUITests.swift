//
//  TravelBookUITests.swift
//  TravelBookUITests
//
//  Created by ddorsat on 02.06.2026.
//

import XCTest

final class TravelBookUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
    }

    @MainActor
    func test_appLaunches_successfully() {
        // Given / When
        app.launch()

        // Then
        XCTAssertEqual(app.state, .runningForeground)
    }

    @MainActor
    func test_tabBar_isVisibleOnLaunch() {
        // Given / When
        app.launch()

        // Then
        XCTAssertTrue(app.tabBars.firstMatch.waitForExistence(timeout: 30))
    }
}
