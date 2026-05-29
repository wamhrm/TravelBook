//
//  SignInCreateAccountButtonView.swift
//  TravelBook
//
//  Created by ddorsat on 04.05.2026.
//

import SwiftUI

struct SignInCreateAccountButtonView: View {
    let type: SignInCreateAccountButtonTypes
    let isSignedOut: Bool
    var isLoading = false
    let onTapHandler: () -> Void

    private var buttonTitle: String {
        return isLoading ? type.loadingTitle : type.rawValue
    }
    
    var body: some View {
        Button(action: onTapHandler) {
            HStack(spacing: 15) {
                if type == .google {
                    Image("google")
                        .resizable()
                        .logoModifier()
                        
                } else if type == .apple {
                    Image(systemName: "apple.logo")
                        .resizable()
                        .logoModifier()
                }
                        
                Text(buttonTitle)
                    .foregroundStyle(isSignedOut ? (type == .signIn ? .white : .black) : type.foregroundColor)
            }
            .font(Components.displaySize(.footnote, .system(size: 14), .callout))
            .bold()
            .padding(Components.displaySize(16, 16, 18))
            .padding(.leading, type == .apple ? -7 : 0)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(isSignedOut && type == .createAccount ? .white : type.backgroundColor)
            .overlay(RoundedRectangle(cornerRadius: 10) .stroke(.black, lineWidth: type == .google ? 0.3 : 0.3))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .disabled(isLoading)
    }
}

enum SignInCreateAccountButtonTypes: String {
    case signIn = "Войти"
    case createAccount = "Создать аккаунт"
    case apple = "Apple"
    case google = "Google"

    var loadingTitle: String {
        switch self {
            case .signIn:
                return "Входим..."
            case .createAccount:
                return "Создаем аккаунт..."
            case .apple, .google:
                return rawValue
        }
    }
    
    var backgroundColor: Color {
        switch self {
            case .signIn, .createAccount:
                return .blue
            case .apple:
                return .black
            case .google:
                return .white
        }
    }
    
    var foregroundColor: Color {
        switch self {
            case .signIn, .createAccount, .apple:
                return .white
            case .google:
                return .black
        }
    }
}

#Preview {
    SignInCreateAccountButtonView(type: .google, isSignedOut: false) {
        
    }
}
