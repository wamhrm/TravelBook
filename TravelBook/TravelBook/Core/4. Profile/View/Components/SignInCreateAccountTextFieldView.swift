//
//  SignInCreateAccountFieldView.swift
//  TravelBook
//
//  Created by ddorsat on 03.05.2026.
//

import SwiftUI
import UIKit

struct SignInCreateAccountTextFieldView: View {
    let type: SignInCreateAccountFieldTypes
    @Binding var field: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(type.rawValue)
                .font(Adaptive.size(.footnote, .system(size: 14), .callout))
                .foregroundStyle(.blackAndWhite)
                .fontWeight(.semibold)
                
            Group {
                if type == .name || type == .email {
                    TextField(type.textField, text: $field)
                        .textInputAutocapitalization(type == .email ? .never : .words)
                        .keyboardType(type == .email ? .emailAddress : .default)
                } else {
                    SecureField(type.textField, text: $field)
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
}

enum SignInCreateAccountFieldTypes: String {
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
    SignInCreateAccountTextFieldView(type: .email, field: .constant(""))
}
