//
//  TestHelpers.swift
//  TravelBookUnitTests
//
//  Created by ddorsat on 02.06.2026.
//

import Foundation

@MainActor
func waitUntil(timeout: TimeInterval = 3, _ condition: () -> Bool) async {
    let deadline = Date().addingTimeInterval(timeout)
    while !condition() {
        if Date() >= deadline { break }
        try? await Task.sleep(for: .milliseconds(10))
    }
}
