//
//  AuthService.swift
//  TravelBook
//
//  Created by ddorsat on 01.01.2026.
//

import Foundation
import Combine

enum AuthState {
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

    private let url = "\(Constants.address)/auth"
    private let tokenPath = Constants.tokenPath
    private let tokenKey = Constants.tokenKey
    private let userKey = Constants.userKey

    init() {
        autoSignIn()
    }

    func createAccount(name: String, email: String, password: String) async throws {
        let url = "\(url)/createAccount"
        let normalizedEmail = normalizeEmail(email)
        let body = UserData(name: name, email: normalizedEmail, password: password)

        let _ = try await NetworkHelper.request(url: url, method: "POST", body: body)

        try await signIn(email: normalizedEmail, password: password)
    }

    func signIn(email: String, password: String) async throws {
        let url = "\(url)/signIn"
        let body = UserData(email: normalizeEmail(email), password: password)
        let data = try await NetworkHelper.request(url: url, method: "POST", body: body)

        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let tokenResponse = try decoder.decode(TokenResponse.self, from: data)

            saveToken(tokenResponse.token)
            saveUserLocally(tokenResponse.user)

            await MainActor.run {
                authState.send(.signedIn(tokenResponse.user))
            }
        } catch {
            throw NetworkError.decodingError
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
        email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }
}

private struct UserData: Encodable {
    let name: String?
    let email: String
    let password: String

    init(name: String? = nil, email: String, password: String) {
        self.name = name
        self.email = email
        self.password = password
    }
}

private struct TokenResponse: Decodable {
    let token: String
    let user: UserModel
}
