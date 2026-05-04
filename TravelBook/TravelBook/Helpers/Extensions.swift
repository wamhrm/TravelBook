//
//  CustomExtensions.swift
//  TravelBook
//
//  Created by ddorsat on 04.01.2026.
//

import Foundation
import SwiftUI

extension View {
    func bottomAreaPadding() -> some View {
        self
            .safeAreaInset(edge: .bottom) { Color.clear.frame(height: 50) }
    }

    func cellDetailsModifier() -> some View {
        self
            .scaledToFill()
            .frame(width: 410, height: 285)
            .clipped()
    }

    func categoryCellViewModifier() -> some View {
        self
            .scaledToFill()
            .frame(width: 200, height: 300)
            .clipped()
    }

    func favoritesCellViewModifier() -> some View {
        self
            .scaledToFill()
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 5))
    }

    func feedHeadCellModifier() -> some View {
        self
            .scaledToFill()
            .frame(width: 370, height: 215)
            .clipped()
            .opacity(0.35)
    }

    func searchSmallCategoriesModifier() -> some View {
        self
            .scaledToFill()
            .frame(width: 50, height: 50)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .clipped()
    }

    func backgroundWithShape(_ amount: CGFloat) -> some View {
        self
            .background(RoundedRectangle(cornerRadius: amount) .fill(.backgroundWithShape))
            .overlay(RoundedRectangle(cornerRadius: amount) .stroke(.black, lineWidth: 0.2))
            .clipShape(RoundedRectangle(cornerRadius: amount))
    }

    func signInTextFieldModifier() -> some View {
        self
            .padding(.vertical, 15)
            .padding(.horizontal, 20)
            .background(.signInTextField)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

extension Date {
    func customMonthYear() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: self).lowercased()
    }
}

extension ColorScheme {
    var isLight: Bool {
        self == .light
    }
}
