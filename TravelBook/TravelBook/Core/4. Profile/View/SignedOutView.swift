//
//  ProfileView.swift
//  TravelBook
//
//  Created by ddorsat on 04.05.2026.
//

import SwiftUI

struct SignedOutView: View {
    @ObservedObject var vm: ProfileViewModel

    var body: some View {
        ZStack {
            BackgroundView()

            VStack(spacing: 55) {
                VStack(spacing: 25) {
                    BigLogo()

                    Text("Ваш профиль путешественника")
                        .font(.title2)
                        .bold()
                        .multilineTextAlignment(.center)
                }

                VStack(spacing: 12) {
                    SignInCreateAccountButtonView(type: .signIn,
                                                  isSignedOut: true,
                                                  isLoading: vm.isLoading) {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            vm.showSignIn.toggle()
                        }
                    }

                    SignInCreateAccountButtonView(type: .createAccount,
                                                  isSignedOut: true,
                                                  isLoading: vm.isLoading) {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            vm.showCreateAccount.toggle()
                        }
                    }
                }
            }
            .padding(.bottom, 115)
            .padding(.horizontal, 40)
        }
        .navigationTitle("Профиль")
        .navigationBarTitleDisplayMode(.inline)
        .overlay {
            overlayView()
        }
        .ignoresSafeArea(.keyboard)
        .alert(vm.alertMessage, isPresented: $vm.showAlert) {
            Button("OK", role: .cancel) {}
        }
    }
}

extension SignedOutView {
    @ViewBuilder
    private func overlayView() -> some View {
        if vm.showSignIn {
            SignInCreateAccountView(vm: vm,
                                    type: .signIn) {
                vm.showSignIn = false
                vm.showCreateAccount = true
            }
        } else if vm.showCreateAccount {
            SignInCreateAccountView(vm: vm,
                                    type: .createAccount) {
                vm.showCreateAccount = false
                vm.showSignIn = true
            }
        }
    }
}

#Preview {
    SignedOutView(vm: ProfileViewModel(authService: AuthService()))
}
