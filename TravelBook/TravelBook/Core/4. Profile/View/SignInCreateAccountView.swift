//
//  SignInCreateAccountView.swift
//  TravelBook
//
//  Created by ddorsat on 03.05.2026.
//

import SwiftUI

struct SignInCreateAccountView: View {
    @ObservedObject var vm: ProfileViewModel
    let type: SignInCreateAccountType
    @Binding var showSignInCreate: Bool
    let onTapHandler: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            HStack {
                Text(type == .signIn ? "Войти" : "Создать аккаунт")
                    .font(.title2)
                    .fontWeight(.semibold)

                Spacer()

                Button {
                    withAnimation(.spring) {
                        showSignInCreate.toggle()
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
                    SignInCreateAccountButtonView(type: .signIn, isSignedOut: false, isLoading: vm.isLoading) {
                        vm.signIn()
                    }
                    .padding(.top, 30)
                }
            } else {
                VStack(spacing: 13) {
                    SignInCreateAccountTextFieldView(type: .name, field: $vm.name)
                    SignInCreateAccountTextFieldView(type: .email, field: $vm.email)
                    SignInCreateAccountTextFieldView(type: .password, field: $vm.password)
                    SignInCreateAccountButtonView(type: .createAccount, isSignedOut: false, isLoading: vm.isLoading) {
                        vm.createAccount()
                    }
                    .padding(.top, 30)
                }
            }

            HStack(spacing: 15) {
                Rectangle()
                    .frame(height: 0.5)

                Text("или")
                    .font(Components.displaySize(.footnote, .system(size: 14), .callout))

                Rectangle()
                    .frame(height: 0.5)
            }
            .foregroundStyle(.gray)

            VStack(spacing: 10) {
                SignInCreateAccountButtonView(type: .google, isSignedOut: false) {

                }

                SignInCreateAccountButtonView(type: .apple, isSignedOut: false) {

                }
            }

            if type == .signIn {
                SignInAlreadyHaveAccountView(type: .signIn) {
                    onTapHandler()
                }
            } else {
                SignInAlreadyHaveAccountView(type: .alreadyHaveAccount) {
                    onTapHandler()
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: type == .signIn ? Components.displaySize(510, 525, 555) : Components.displaySize(590, 605, 635))
        .padding(25)
        .background(RoundedRectangle(cornerRadius: 15) .fill(.backgroundWithShape))
        .padding(.horizontal)
        .dismissKeyboardOnTap()
        .onDisappear {
            vm.clearTextFields()
        }
    }
}

enum SignInCreateAccountType: String {
    case signIn = "Войти"
    case createAccount = "Создать аккаунт"
}

#Preview {
    NavigationStack {
        ZStack {
            Components.backgroundColor()
            SignInCreateAccountView(vm: ProfileViewModel(authService: AuthService()), type: .createAccount, showSignInCreate: .constant(true)) {

            }
        }
        .navigationTitle("Профиль")
        .navigationBarTitleDisplayMode(.inline)
    }
}
