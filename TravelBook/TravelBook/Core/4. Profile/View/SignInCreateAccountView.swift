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

    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            HStack {
                Text(type == .signIn ? "Войти" : "Создать аккаунт")
                    .font(.title2)
                    .fontWeight(.semibold)

                Spacer()

                Button {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        vm.dismissSignInCreateViews()
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
                    textFieldView(type: .email, field: $vm.email)
                    textFieldView(type: .password, field: $vm.password)
                    SignInCreateAccountButtonView(type: .signIn,
                                                  isSignedOut: false,
                                                  isLoading: vm.isLoading) {
                        vm.signIn()
                    }
                    .padding(.top, 30)
                }
            } else {
                VStack(spacing: 13) {
                    textFieldView(type: .name, field: $vm.name)
                    textFieldView(type: .email, field: $vm.email)
                    textFieldView(type: .password, field: $vm.password)
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
                alreadyHaveAccountView(type: .signIn) {
                    withAnimation {
                        vm.toggleSignInCreateView()
                    }
                }
            } else {
                alreadyHaveAccountView(type: .alreadyHaveAccount) {
                    withAnimation {
                        vm.toggleSignInCreateView()
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
            vm.dismissSignInCreateViews()
        }
    }
}

extension SignInCreateAccountView {
    private func textFieldView(type: TextFieldTypes,
                               field: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(type.rawValue)
                .font(Adaptive.size(.footnote, .system(size: 14), .callout))
                .foregroundStyle(.blackAndWhite)
                .fontWeight(.semibold)
                
            Group {
                if type == .name || type == .email {
                    TextField(type.textField, text: field)
                        .textInputAutocapitalization(type == .email ? .never : .words)
                        .keyboardType(type == .email ? .emailAddress : .default)
                } else {
                    SecureField(type.textField, text: field)
                        .textInputAutocapitalization(.never)
                }
            }
            .font(Adaptive.size(.footnote, .system(size: 14), .callout))
            .frame(maxWidth: .infinity)
            .frame(height: Adaptive.size(20, 20, 22))
            .padding(15)
            .background(.signInTextField)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .autocorrectionDisabled(type == .email || type == .password)
        }
    }
    
    private func alreadyHaveAccountView(type: AlreadyHaveAccountButtonTypes,
                                        onTapHandler: @escaping () -> Void) -> some View {
        Button(action: onTapHandler) {
            HStack {
                Spacer()

                Text(type.rawValue)
                    .foregroundStyle(.blackAndWhite)

                Text(type.buttonTitle)
                    .foregroundStyle(.blue)
                    .bold()

                Spacer()
            }
            .font(Adaptive.size(.footnote, .system(size: 14), .callout))
        }
    }
}

enum SignInCreateAccountTypes: String {
    case signIn = "Войти"
    case createAccount = "Создать аккаунт"
}

fileprivate enum AlreadyHaveAccountButtonTypes: String {
    case signIn = "Нет аккаунта?"
    case alreadyHaveAccount = "Уже есть аккаунт?"
    
    var buttonTitle: String {
        switch self {
            case .signIn: "Создать аккаунт"
            case .alreadyHaveAccount: "Войти"
        }
    }
}

fileprivate enum TextFieldTypes: String {
    case name = "Имя"
    case email = "Почта"
    case password = "Пароль"
    
    var textField: String {
        switch self {
            case .name: "Введите ваше имя"
            case .email: "Введите вашу почту"
            case .password: "Введите ваш пароль"
        }
    }
}


#Preview {
    NavigationStack {
        ZStack {
            BackgroundView()
            SignInCreateAccountView(vm: ProfileViewModel(authService: AuthService()),
                                    type: .createAccount)
        }
        .navigationTitle("Профиль")
        .navigationBarTitleDisplayMode(.inline)
    }
}
