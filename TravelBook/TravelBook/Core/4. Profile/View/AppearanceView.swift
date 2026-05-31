//
//  AppearanceView.swift
//  TravelBook
//
//  Created by ddorsat on 03.01.2026.
//

import SwiftUI

struct AppearanceView: View {
    @AppStorage(Constants.selectedThemeKey) private var selectedTheme = AppTheme.system

    var body: some View {
        ZStack {
            BackgroundView()
            
            List {
                Section {
                    ForEach(AppTheme.allCases, id: \.self) { theme in
                        Button {
                            selectedTheme = theme
                        } label: {
                            HStack {
                                Text(theme.rawValue)
                                    .foregroundStyle(.title)
                                                            
                                Spacer()
                                                            
                                if selectedTheme == theme {
                                    Image(systemName: "checkmark")
                                        .resizable()
                                        .foregroundStyle(.blue)
                                        .fontWeight(.semibold)
                                        .frame(width: 17, height: 14)
                                        .clipped()
                                        .padding(.trailing, 10)
                                }
                            }
                        }
                    }
                } header: {
                    Text("ТЕМА ПРИЛОЖЕНИЯ")
                        .font(.callout)
                        .foregroundStyle(.gray)
                        .fontWeight(.medium)
                }
            }
            .navigationTitle("Оформление")
            .navigationBarTitleDisplayMode(.inline)
            .foregroundStyle(.black)
        }
    }
}

enum AppTheme: String, CaseIterable {
    case light = "Светлая"
    case dark = "Темная"
    case system = "Системная"
    
    var colorScheme: ColorScheme? {
        switch self {
            case .light: .light
            case .dark: .dark
            case .system: nil
        }
    }
}

#Preview {
    AppearanceView()
}
