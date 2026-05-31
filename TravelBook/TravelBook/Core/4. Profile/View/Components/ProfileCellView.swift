//
//  ProfileCellView.swift
//  TravelBook
//
//  Created by ddorsat on 03.01.2026.
//

import SwiftUI

struct ProfileCellView: View {
    let type: ProfileCellTypes
    let isLoading: Bool?
    let onTapHandler: () -> Void

    init(type: ProfileCellTypes,
         isLoading: Bool? = nil,
         onTapHandler: @escaping () -> Void) {
        self.type = type
        self.isLoading = isLoading
        self.onTapHandler = onTapHandler
    }
    
    private var isLoadingHandler: Bool {
        isLoading ?? false
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
                    .font(Adaptive.size(.system(size: 14), .system(size: 15), .callout))
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
        .disabled(isLoadingHandler && type == .signOut)
    }
}

enum ProfileCellTypes: String {
    case appearance = "Оформление"
    case aboutApp = "О приложении"
    case signOut = "Выйти"
    
    fileprivate var icon: String {
        switch self {
            case .appearance: "paintpalette.fill"
            case .aboutApp: "info.circle.fill"
            case .signOut: "rectangle.portrait.and.arrow.right"
        }
    }

    fileprivate var backgroundColor: Color {
        switch self {
            case .appearance: .green
            case .aboutApp: .gray
            case .signOut: .red
        }
    }
}

#Preview {
    VStack {
        ProfileCellView(type: .appearance, isLoading: false) {
            
        }
    }
    .padding(.horizontal)
}
