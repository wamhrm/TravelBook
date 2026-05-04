//
//  ProfileViewModel.swift
//  TravelBook
//
//  Created by ddorsat on 03.01.2026.
//

import Foundation
import SwiftUI
import Combine

enum ProfileRoutes: Hashable {
    case appearance, aboutApp
}

enum AuthInput {
    static let minPasswordLength = 6
    static let minNameLength = 2
    static let authActionDelay = Duration.seconds(1)
}

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""

    @Published var profileRoutes: [ProfileRoutes] = []
    @Published private(set) var authState = AuthState.signedOut
    @Published private(set) var isLoading = false

    @Published private(set) var showError = false
    @Published private(set) var errorMessage = ""

    private var authService: any AuthServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(authService: any AuthServiceProtocol) {
        self.authService = authService

        setupSubscriptions()
    }

    deinit {
        cancellables.removeAll()
    }

    private func setupSubscriptions() {
        authService.authState
            .receive(on: RunLoop.main)
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
            presentAuthError(message)
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
                handleError(error)
            }

            isLoading = false
        }
    }

    func signIn() {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)

        if let message = validateSignIn(email: trimmedEmail, password: password) {
            presentAuthError(message)
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
                handleError(error)
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

    func authErrorAlertPresented() -> Binding<Bool> {
        Binding(get: { self.showError },
                set: { newValue in
                if !newValue {
                    self.showError = false
                }
            }
        )
    }

    private func handleError(_ error: Error) {
        if let authError = error as? NetworkError {
            presentAuthError(authError.errorDescription ?? "Произошла неизвестная ошибка")
        } else {
            presentAuthError(error.localizedDescription)
        }
    }

    private func presentAuthError(_ message: String) {
        showError = true
        errorMessage = message
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



