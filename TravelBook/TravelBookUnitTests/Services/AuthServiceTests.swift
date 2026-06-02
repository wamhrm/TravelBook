//
//  AuthServiceTests.swift
//  TravelBookUnitTests
//
//  Created by ddorsat on 02.06.2026.
//

import Combine
import XCTest
@testable import TravelBook

@MainActor
final class AuthServiceTests: XCTestCase {
    override func setUp() {
        super.setUp()
        UserDefaults.standard.removeObject(forKey: Constants.userKey)
    }

    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: Constants.userKey)
        super.tearDown()
    }

    func test_signIn_savesTokenAndUserAndEmitsSignedIn() async throws {
        // Given
        let keychain = MockKeychain()
        let network = MockNetworkService()
        let sut = makeSUT(keychain: keychain, network: network)

        // When
        try await sut.signIn(email: "a@b.com", password: "123456")

        // Then
        XCTAssertNotNil(keychain.read(path: "", key: ""))
        XCTAssertNotNil(UserDefaults.standard.data(forKey: Constants.userKey))
        XCTAssertEqual(sut.authState.value, .signedIn(network.authTokenResponse.user))
    }

    func test_signOut_clearsTokenAndUserAndEmitsSignedOut() async throws {
        // Given
        let keychain = MockKeychain()
        let sut = makeSUT(keychain: keychain)
        try await sut.signIn(email: "a@b.com", password: "123456")

        // When
        sut.signOut()

        // Then
        XCTAssertNil(keychain.read(path: "", key: ""))
        XCTAssertNil(UserDefaults.standard.data(forKey: Constants.userKey))
        XCTAssertEqual(sut.authState.value, .signedOut)
    }

    func test_createAccount_callsNetworkThenSignsIn() async throws {
        // Given
        let network = MockNetworkService()
        let sut = makeSUT(network: network)

        // When
        try await sut.createAccount(name: "Имя", email: "a@b.com", password: "123456")

        // Then
        XCTAssertEqual(network.createAccountCallCount, 1)
        XCTAssertEqual(network.signInCallCount, 1)
        XCTAssertEqual(sut.authState.value, .signedIn(network.authTokenResponse.user))
    }

    func test_autoSignIn_whenTokenAndUserExist_emitsSignedIn() throws {
        // Given
        let user = UserModel.mock
        UserDefaults.standard.set(try JSONEncoder().encode(user), forKey: Constants.userKey)
        let keychain = MockKeychain(token: Data("token".utf8))

        // When
        let sut = makeSUT(keychain: keychain)

        // Then
        XCTAssertEqual(sut.authState.value, .signedIn(user))
    }

    func test_autoSignIn_whenNoToken_emitsSignedOut() {
        // Given / When
        let sut = makeSUT(keychain: MockKeychain())

        // Then
        XCTAssertEqual(sut.authState.value, .signedOut)
    }
    
    // MARK: - Helpers
    private func makeSUT(keychain: MockKeychain = MockKeychain(),
                         network: MockNetworkService? = nil) -> AuthService {
        AuthService(networkService: network ?? MockNetworkService(), keychain: keychain)
    }
}
