//
//  AppearanceViewModel.swift
//  TravelBook
//
//  Created by ddorsat on 09.01.2026.
//

import Foundation
import Combine

final class AppearanceViewModel: ObservableObject {
    @Published private(set) var currentTheme: AppTheme = .system
    
    private let themeKey = "selectedTheme"
        
    init() { loadTheme() }
    
    func setTheme(_ theme: AppTheme) {
        self.currentTheme = theme
        
        saveTheme(theme)
    }
    
    private func loadTheme() {
        if let savedString = UserDefaults.standard.string(forKey: themeKey),
           let theme = AppTheme(rawValue: savedString) {
            self.currentTheme = theme
        } else {
            self.currentTheme = .system
        }
    }
    
    private func saveTheme(_ theme: AppTheme) {
        UserDefaults.standard.set(theme.rawValue, forKey: themeKey)
    }
}
