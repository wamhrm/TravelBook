//
//  AuthService.swift
//  TravelBook
//
//  Created by ddorsat on 01.01.2026.
//

import Foundation
import Combine

enum AuthState: Equatable {
    case signedIn(UserModel)
    case signedOut
}

protocol AuthServiceProtocol: ObservableObject {
    var authState: CurrentValueSubject<AuthState, Never> { get }

    func createAccount(name: String, email: String, password: String) async throws
    func signIn(email: String, password: String) async throws
    func signOut()
}

final class AuthService: AuthServiceProtocol {
    var authState = CurrentValueSubject<AuthState, Never>(.signedOut)

    private let tokenPath = Constants.tokenPath
    private let tokenKey = Constants.tokenKey
    private let userKey = Constants.userKey

    private let networkService: any NetworkServiceProtocol

    init(networkService: any NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
        autoSignIn()
    }

    func createAccount(name: String, email: String, password: String) async throws {
        let normalizedEmail = normalizeEmail(email)
        try await networkService.createAccount(name: name, email: normalizedEmail, password: password)
        try await signIn(email: normalizedEmail, password: password)
    }

    func signIn(email: String, password: String) async throws {
        let response = try await networkService.signIn(email: normalizeEmail(email), password: password)

        saveToken(response.token)
        saveUserLocally(response.user)

        await MainActor.run {
            authState.send(.signedIn(response.user))
        }
    }

    func signOut() {
        KeychainHelper.standard.delete(path: tokenPath, key: tokenKey)
        UserDefaults.standard.removeObject(forKey: userKey)
        authState.send(.signedOut)
    }

    private func autoSignIn() {
        if let _ = KeychainHelper.standard.read(path: tokenPath, key: tokenKey),
           let userData = UserDefaults.standard.data(forKey: userKey),
           let user = try? JSONDecoder().decode(UserModel.self, from: userData) {
            authState.send(.signedIn(user))
        } else {
            authState.send(.signedOut)
        }
    }

    private func saveUserLocally(_ user: UserModel) {
        if let data = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(data, forKey: userKey)
        }
    }

    private func saveToken(_ token: String) {
        if let data = token.data(using: .utf8) {
            KeychainHelper.standard.save(data, path: tokenPath, key: tokenKey)
        }
    }

    private func normalizeEmail(_ email: String) -> String {
        return email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }
}
