//
//  SignInAlreadyHaveAccountView.swift
//  TravelBook
//
//  Created by ddorsat on 04.05.2026.
//

import SwiftUI

struct SignInAlreadyHaveAccountView: View {
    @Environment(\.displayScale) var displayScale
    let type: SignInAlreadyHaveAccountType
    let onTapHandler: () -> Void
    
    var body: some View {
        HStack {
            Spacer()
            
            Text(type.rawValue)
                .font(UIDevice.isProMax ? .callout : .footnote)
                .foregroundStyle(.blackAndWhite)
            
            Button {
                onTapHandler()
            } label: {
                Text(type.buttonTitle)
                    .font(UIDevice.isProMax ? .callout : .footnote)
                    .foregroundStyle(.blue)
                    .bold()
            }
            
            Spacer()
        }
        .font(.callout)
    }
}

enum SignInAlreadyHaveAccountType: String {
    case signIn = "Нет аккаунта?"
    case alreadyHaveAccount = "Уже есть аккаунт?"
    
    var buttonTitle: String {
        switch self {
            case .signIn: 
                return "Создать аккаунт"
            case .alreadyHaveAccount: 
                return "Войти"
        }
    }
}

#Preview {
    SignInAlreadyHaveAccountView(type: .signIn) {
        
    }
}
