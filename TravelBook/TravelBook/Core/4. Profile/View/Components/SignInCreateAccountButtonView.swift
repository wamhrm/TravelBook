//
//  SignInCreateAccountButtonView.swift
//  TravelBook
//
//  Created by ddorsat on 04.05.2026.
//

import SwiftUI

struct SignInCreateAccountButtonView: View {
    let type: SignInCreateAccountButtonType
    let signedOut: Bool
    let onTapHandler: () -> Void
    
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
                        
                if !signedOut {
                    Text(type.rawValue)
                        .foregroundStyle(type.foregroundColor)
                    
                } else {
                    Text(type.rawValue)
                        .foregroundStyle(type == .signIn ? .white : .black)
                }
            }
            .font(Components.isProMax(.callout, .footnote))
            .bold()
            .padding(Components.isProMax(18, 16))
            .padding(.leading, type == .apple ? -7 : 0)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(signedOut && type == .createAccount ? .white : type.backgroundColor)
            .background(signedOut && type == .signIn ? .blue : type.backgroundColor)
            .overlay(RoundedRectangle(cornerRadius: 10) .stroke(.black, lineWidth: type == .google ? 0.3 : 0.3))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

enum SignInCreateAccountButtonType: String {
    case signIn = "Войти"
    case createAccount = "Создать аккаунт"
    case apple = "Apple"
    case google = "Google"
    
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
    SignInCreateAccountButtonView(type: .google, signedOut: false) {
        
    }
}
