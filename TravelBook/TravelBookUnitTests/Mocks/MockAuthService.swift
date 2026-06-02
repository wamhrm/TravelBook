//
//  MockAuthService.swift
//  TravelBookUnitTests
//
//  Created by ddorsat on 02.06.2026.
//

import Combine
import Foundation
@testable import TravelBook

enum MockError: Error {
    case notStubbed
}

@MainActor
final class MockAuthService: AuthServiceProtocol {
    let authState: CurrentValueSubject<AuthState, Never>

    var errorToThrow: Error?

    private(set) var signInCallCount = 0
    private(set) var createAccountCallCount = 0
    private(set) var signOutCallCount = 0

    init(state: AuthState = .signedOut) {
        authState = CurrentValueSubject<AuthState, Never>(state)
    }

    func createAccount(name: String, email: String, password: String) async throws {
        createAccountCallCount += 1
        if let errorToThrow { throw errorToThrow }
    }

    func signIn(email: String, password: String) async throws {
        signInCallCount += 1
        if let errorToThrow { throw errorToThrow }
    }

    func signOut() {
        signOutCallCount += 1
        authState.send(.signedOut)
    }
}
