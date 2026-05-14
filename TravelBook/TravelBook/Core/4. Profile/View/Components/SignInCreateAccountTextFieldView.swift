//
//  SignInCreateAccountFieldView.swift
//  TravelBook
//
//  Created by ddorsat on 03.05.2026.
//

import SwiftUI

struct SignInCreateAccountTextFieldView: View {
    let type: SignInCreateAccountFieldType
    @Binding var field: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(type.rawValue)
                .font(UIDevice.isProMax ? .callout : .footnote)
                .foregroundStyle(.blackAndWhite)
                .fontWeight(.semibold)
                
            if type == .name || type == .email {
                TextField(type.textField, text: $field)
                    .signInTextFieldModifier()
                    .textInputAutocapitalization(type == .email ? .never : .words)
            } else {
                SecureField(type.textField, text: $field)
                    .signInTextFieldModifier()
                    .textInputAutocapitalization(.never)
            }
        }
    }
}

enum SignInCreateAccountFieldType: String {
    case name = "Имя"
    case email = "Почта"
    case password = "Пароль"
    
    var textField: String {
        switch self {
            case .name: 
                return "Введите ваше имя"
            case .email: 
                return "Введите вашу почту"
            case .password: 
                return "Введите ваш пароль"
        }
    }
}

#Preview {
    SignInCreateAccountTextFieldView(type: .email, field: .constant(""))
}
