//
//  ProfileView.swift
//  TravelBook
//
//  Created by ddorsat on 04.05.2026.
//

import SwiftUI

struct SignedOutView: View {
    @ObservedObject var vm: ProfileViewModel
    @State var showSignIn = false
    @State var showCreateAccount = false

    var body: some View {
        ZStack {
            Components.backgroundColor()

            VStack(spacing: 55) {
                VStack(spacing: 25) {
                    Components.bigLogo()

                    Text("Ваш профиль путешественника")
                        .font(.title2)
                        .bold()
                        .multilineTextAlignment(.center)
                }

                VStack(spacing: 12) {
                    SignInCreateAccountButtonView(type: .signIn, signedOut: true) {
                        withAnimation(.spring) {
                            showSignIn.toggle()
                        }
                    }

                    SignInCreateAccountButtonView(type: .createAccount, signedOut: true) {
                        withAnimation(.spring) {
                            showCreateAccount.toggle()
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
            if showSignIn {
                SignInCreateAccountView(vm: vm, type: .signIn, showSignInCreate: $showSignIn) {
                    showSignIn = false
                    showCreateAccount = true
                }
            } else if showCreateAccount {
                SignInCreateAccountView(vm: vm, type: .createAccount, showSignInCreate: $showCreateAccount) {
                    showCreateAccount = false
                    showSignIn = true
                }
            }
        }
        .ignoresSafeArea(.keyboard)
        .alert(vm.errorMessage, isPresented: $vm.showError) {
            Button("OK", role: .cancel) {}
        }
    }
}

#Preview {
    SignedOutView(vm: ProfileViewModel(authService: AuthService()))
}
