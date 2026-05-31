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
    let isLoading: Bool
    let onTapHandler: () -> Void
    
    init(type: SignInCreateAccountButtonTypes,
         isSignedOut: Bool,
         isLoading: Bool,
         onTapHandler: @escaping () -> Void) {
        self.type = type
        self.isSignedOut = isSignedOut
        self.isLoading = isLoading
        self.onTapHandler = onTapHandler
    }
    

    private var buttonTitle: String {
        isLoading ? type.loadingTitle : type.rawValue
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
            .font(Adaptive.size(.footnote, .system(size: 14), .callout))
            .bold()
            .padding(Adaptive.size(16, 16, 18))
            .padding(.leading, type == .apple ? -7 : 0)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(isSignedOut && type == .createAccount ? .white : type.backgroundColor)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 0.3))
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
            case .signIn: "Входим..."
            case .createAccount: "Создаем аккаунт..."
            case .apple, .google: rawValue
        }
    }

    var backgroundColor: Color {
        switch self {
            case .signIn, .createAccount: .blue
            case .apple: .black
            case .google: .white
        }
    }

    var foregroundColor: Color {
        switch self {
            case .signIn, .createAccount, .apple: .white
            case .google: .black
        }
    }
}

#Preview {
    SignInCreateAccountButtonView(type: .google, isSignedOut: false, isLoading: false) {
        
    }
}
