//
//  SignInAlreadyHaveAccountView.swift
//  TravelBook
//
//  Created by ddorsat on 04.05.2026.
//

import SwiftUI

struct SignInAlreadyHaveAccountView: View {
    @Environment(\.displayScale) var displayScale
    let type: SignInAlreadyHaveAccountTypes
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
        .font(Adaptive.size(.footnote, .system(size: 14), .callout))
    }
}

enum SignInAlreadyHaveAccountTypes: String {
    case signIn = "Нет аккаунта?"
    case alreadyHaveAccount = "Уже есть аккаунт?"
    
    var buttonTitle: String {
        switch self {
            case .signIn: "Создать аккаунт"
            case .alreadyHaveAccount: "Войти"
        }
    }
}

#Preview {
    SignInAlreadyHaveAccountView(type: .signIn) {
        
    }
}
