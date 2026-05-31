//
//  SignInCreateAccountView.swift
//  TravelBook
//
//  Created by ddorsat on 03.05.2026.
//

import SwiftUI

struct SignInCreateAccountView: View {
    @ObservedObject var vm: ProfileViewModel
    let type: SignInCreateAccountTypes
    let onTapHandler: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            HStack {
                Text(type == .signIn ? "Войти" : "Создать аккаунт")
                    .font(.title2)
                    .fontWeight(.semibold)

                Spacer()

                Button {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        vm.dismissSignInCreateView()
                    }
                } label: {
                    Image(systemName: "xmark")
                        .imageScale(.small)
                        .foregroundStyle(.blackAndWhite)
                        .fontWeight(.semibold)
                        .padding(10)
                        .background(.signInCreateXmarkButton)
                        .clipShape(Circle())
                }
            }

            if type == .signIn {
                VStack(spacing: 13) {
                    SignInCreateAccountTextFieldView(type: .email, field: $vm.email)
                    SignInCreateAccountTextFieldView(type: .password, field: $vm.password)
                    SignInCreateAccountButtonView(type: .signIn,
                                                  isSignedOut: false,
                                                  isLoading: vm.isLoading) {
                        vm.signIn()
                    }
                    .padding(.top, 30)
                }
            } else {
                VStack(spacing: 13) {
                    SignInCreateAccountTextFieldView(type: .name, field: $vm.name)
                    SignInCreateAccountTextFieldView(type: .email, field: $vm.email)
                    SignInCreateAccountTextFieldView(type: .password, field: $vm.password)
                    SignInCreateAccountButtonView(type: .createAccount,
                                                  isSignedOut: false,
                                                  isLoading: vm.isLoading) {
                        vm.createAccount()
                    }
                    .padding(.top, 30)
                }
            }

            HStack(spacing: 15) {
                Rectangle()
                    .frame(height: 0.5)

                Text("или")
                    .font(Adaptive.size(.footnote, .system(size: 14), .callout))

                Rectangle()
                    .frame(height: 0.5)
            }
            .foregroundStyle(.gray)

            VStack(spacing: 10) {
                SignInCreateAccountButtonView(type: .google,
                                              isSignedOut: false,
                                              isLoading: vm.isLoading) {}
                SignInCreateAccountButtonView(type: .apple,
                                              isSignedOut: false,
                                              isLoading: vm.isLoading) {}
            }

            if type == .signIn {
                SignInAlreadyHaveAccountView(type: .signIn) {
                    withAnimation {
                        onTapHandler()
                    }
                }
            } else {
                SignInAlreadyHaveAccountView(type: .alreadyHaveAccount) {
                    withAnimation {
                        onTapHandler()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: type == .signIn ? Adaptive.size(510, 525, 555) : Adaptive.size(590, 605, 635))
        .padding(25)
        .background(RoundedRectangle(cornerRadius: 15).fill(.backgroundWithShape))
        .padding(.horizontal)
        .dismissKeyboardOnTap()
        .onDisappear {
            vm.clearTextFields()
            vm.dismissSignInCreateView()
        }
    }
}

enum SignInCreateAccountTypes: String {
    case signIn = "Войти"
    case createAccount = "Создать аккаунт"
}

#Preview {
    NavigationStack {
        ZStack {
            BackgroundView()
            SignInCreateAccountView(vm: ProfileViewModel(authService: AuthService()),
                                    type: .createAccount) {

            }
        }
        .navigationTitle("Профиль")
        .navigationBarTitleDisplayMode(.inline)
    }
}
