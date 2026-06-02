//
//  MockKeychain.swift
//  TravelBookUnitTests
//
//  Created by ddorsat on 02.06.2026.
//

import Foundation
@testable import TravelBook

nonisolated final class MockKeychain: KeychainHelperProtocol, @unchecked Sendable {
    private let lock = NSLock()
    private var token: Data?

    init(token: Data? = nil) {
        self.token = token
    }

    func save(_ data: Data, path: String, key: String) {
        lock.withLock { token = data }
    }

    func read(path: String, key: String) -> Data? {
        lock.withLock { token }
    }

    func delete(path: String, key: String) {
        lock.withLock { token = nil }
    }
}
