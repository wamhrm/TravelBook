//
//  ProfileCellView.swift
//  TravelBook
//
//  Created by ddorsat on 03.01.2026.
//

import SwiftUI

struct ProfileCellView: View {
    let user: UserModel?
    let type: ProfileCellType
    let onTapHandler: () -> Void
    
    init(user: UserModel? = nil, type: ProfileCellType, onTapHandler: @escaping () -> Void) {
        self.user = user
        self.type = type
        self.onTapHandler = onTapHandler
    }
    
    var body: some View {
        Button(action: onTapHandler) {
            HStack(spacing: 15) {
                ZStack {
                    RoundedRectangle(cornerRadius: 7)
                        .foregroundStyle(type.backgroundColor)
                        .frame(width: 32, height: 32)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    
                    Image(systemName: type.icon)
                        .foregroundStyle(.white)
                        .font(.system(size: 18))
                }
                
                Text(type.rawValue)
                    .font(UIDevice.isProMax ? .callout : .system(size: 14))
                    .foregroundStyle(.blackAndWhite)
                    .fontWeight(.medium)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color(uiColor: .systemGray3))
                    .fontWeight(.semibold)
            }
            .padding(15)
            .backgroundWithShape(10)
        }
    }
}

enum ProfileCellType: String {
    case appearance = "Оформление"
    case aboutApp = "О приложении"
    case logOut = "Выйти"
    
    var icon: String {
        switch self {
            case .appearance:  
                return "paintpalette.fill"
            case .aboutApp: 
                return "info.circle.fill"
            case .logOut: 
                return "rectangle.portrait.and.arrow.right"
        }
    }
    
    var backgroundColor: Color {
        switch self {
            case .appearance:
                return .green
            case .aboutApp:
                return .gray
            case .logOut:
                return .red
        }
    }
}

#Preview {
    VStack {
        ProfileCellView(user: .mock, type: .appearance) {
            
        }
    }
    .padding(.horizontal)
}
