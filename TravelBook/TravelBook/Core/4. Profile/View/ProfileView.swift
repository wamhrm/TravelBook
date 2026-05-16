//
//  ProfileView.swift
//  TravelBook
//
//  Created by ddorsat on 04.05.2026.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var vm: ProfileViewModel

    var body: some View {
        NavigationStack(path: $vm.profileRoutes) {
            Group {
                if case .signedIn(let user) = vm.authState {
                    SignedInView(vm: vm, user: user)
                        .transition(.opacity.combined(with: .move(edge: .trailing)))
                } else {
                    SignedOutView(vm: vm)
                        .transition(.opacity.combined(with: .move(edge: .leading)))
                }
            }
            .navigationTitle("Профиль")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: ProfileRoutes.self) { destination in
                destinationView(destination)
            }
            .overlay {
                if vm.isLoading {
                    ProgressView()
                }
            }
        }
    }
}

extension ProfileView {
    @ViewBuilder
    private func destinationView(_ route: ProfileRoutes) -> some View {
        switch route {
            case .appearance:
                AppearanceView()
            case .aboutApp:
                AboutAppView()
        }
    }
}


#Preview {
    ProfileView(vm: ProfileViewModel(authService: AuthService()))
}
