//
//  ProfileViewModel.swift
//  TravelBook
//
//  Created by ddorsat on 03.01.2026.
//

import Combine
import Foundation
import SwiftUI

enum ProfileRoutes: Hashable {
    case appearance, aboutApp
}

private enum AuthInput {
    static let minPasswordLength = 6
    static let minNameLength = 2
    static let authActionDelay = Duration.seconds(1)
}

@MainActor
final class ProfileViewModel: ObservableObject, AlertPresentable {
    @Published var profileRoutes: [ProfileRoutes] = []
    @Published private(set) var authState = AuthState.signedOut

    @Published var name = ""
    @Published var email = ""
    @Published var password = ""

    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published private(set) var isLoading = false
    
    @Published var showCreateAccount = false
    @Published var showSignIn = false
    @Published var showSignOut = false

    private let authService: any AuthServiceProtocol
    
    private var cancellables = Set<AnyCancellable>()

    init(authService: any AuthServiceProtocol) {
        self.authService = authService
        setupSubscriptions()
    }

    private func setupSubscriptions() {
        authService.authState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] authState in
                withAnimation(.easeInOut(duration: 0.25)) {
                    self?.authState = authState
                }
            }
            .store(in: &cancellables)
    }

    func createAccount() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)

        if let message = validateCreateAccount(name: trimmedName, email: trimmedEmail, password: password) {
            presentAlert(message)
            return
        }

        guard !isLoading else { return }

        isLoading = true

        Task {
            do {
                try await Task.sleep(for: AuthInput.authActionDelay)
                try await authService.createAccount(name: trimmedName, email: trimmedEmail, password: password)
                profileRoutes = []
            } catch {
                presentAlert(error.localizedDescription)
            }

            isLoading = false
        }
    }

    func signIn() {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)

        if let message = validateSignIn(email: trimmedEmail, password: password) {
            presentAlert(message)
            return
        }

        guard !isLoading else { return }

        isLoading = true

        Task {
            do {
                try await Task.sleep(for: AuthInput.authActionDelay)
                try await authService.signIn(email: trimmedEmail, password: password)
                profileRoutes = []
            } catch {
                presentAlert(error.localizedDescription)
            }

            isLoading = false
        }
    }

    func signOut() {
        guard !isLoading else { return }

        isLoading = true

        Task {
            try? await Task.sleep(for: AuthInput.authActionDelay)
            authService.signOut()
            profileRoutes = []
            isLoading = false
        }
    }

    func clearTextFields() {
        name = ""
        email = ""
        password = ""
    }
    
    func dismissSignInCreateViews() {
        showSignIn = false
        showCreateAccount = false
    }

    func toggleSignInCreateView() {
        showSignIn.toggle()
        showCreateAccount.toggle()
    }

    private func validateSignIn(email: String, password: String) -> String? {
        if email.isEmpty, password.isEmpty {
            return "Заполните почту и пароль"
        }
        if email.isEmpty {
            return "Укажите почту"
        }
        if password.isEmpty {
            return "Укажите пароль"
        }
        if !Self.isValidEmail(email) {
            return "Укажите корректный e-mail"
        }
        if password.count < AuthInput.minPasswordLength {
            return "Пароль должен быть не короче \(AuthInput.minPasswordLength) символов"
        }
        return nil
    }

    private func validateCreateAccount(name: String, email: String, password: String) -> String? {
        if name.isEmpty, email.isEmpty, password.isEmpty {
            return "Заполните имя, почту и пароль"
        }
        if name.isEmpty {
            return "Укажите имя"
        }
        if email.isEmpty {
            return "Укажите почту"
        }
        if password.isEmpty {
            return "Укажите пароль"
        }
        if name.count < AuthInput.minNameLength {
            return "Имя должно содержать минимум \(AuthInput.minNameLength) символа"
        }
        if !Self.isValidEmail(email) {
            return "Укажите корректный e-mail"
        }
        if password.count < AuthInput.minPasswordLength {
            return "Пароль должен быть не короче \(AuthInput.minPasswordLength) символов"
        }
        return nil
    }

    private static func isValidEmail(_ email: String) -> Bool {
        let parts = email.split(separator: "@", omittingEmptySubsequences: false)
        guard parts.count == 2 else { return false }
        let local = parts[0]
        let domain = parts[1]
        return !local.isEmpty && !domain.isEmpty
    }
}

