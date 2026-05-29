//
//  SignInCreateAccountFieldView.swift
//  TravelBook
//
//  Created by ddorsat on 03.05.2026.
//

import SwiftUI
import UIKit

struct SignInCreateAccountTextFieldView: View {
    let type: SignInCreateAccountFieldType
    @Binding var field: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(type.rawValue)
                .font(Components.displaySize(.footnote, .system(size: 14), .callout))
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
            .font(Components.displaySize(.footnote, .system(size: 14), .callout))
            .frame(maxWidth: .infinity)
            .frame(height: Components.displaySize(20, 20, 22))
            .padding(15)
            .background(.signInTextField)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .autocorrectionDisabled(type == .email || type == .password)
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
