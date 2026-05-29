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
                .foregroundStyle(.blackAndWhite)
            
            Button {
                onTapHandler()
            } label: {
                Text(type.buttonTitle)
                    .foregroundStyle(.blue)
                    .bold()
            }
            
            Spacer()
        }
        .font(Components.displaySize(.footnote, .system(size: 14), .callout))
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
