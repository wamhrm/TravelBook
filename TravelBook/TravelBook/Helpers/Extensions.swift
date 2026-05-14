//
//  CustomExtensions.swift
//  TravelBook
//
//  Created by ddorsat on 04.01.2026.
//

import Foundation
import SwiftUI
import UIKit

extension View {
    func bottomAreaPadding() -> some View {
        self
            .safeAreaInset(edge: .bottom) { Color.clear.frame(height: 50) }
    }

    func cellDetailsModifier() -> some View {
        self
            .scaledToFill()
            .frame(width: UIDevice.isProMax ? 447 : 410, height: UIDevice.isProMax ? 322 : 285)
            .clipped()
    }

    func categoryCellViewModifier() -> some View {
        self
            .scaledToFill()
            .frame(width: UIDevice.isProMax ? 237 : 200, height: UIDevice.isProMax ? 337 : 300)
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
            .frame(width: UIDevice.isProMax ? 407 : 370, height: UIDevice.isProMax ? 252 : 215)
            .clipped()
            .opacity(0.35)
    }

    func searchSmallCategoriesModifier() -> some View {
        self
            .scaledToFill()
            .frame(width: UIDevice.isProMax ? 50 : 45, height: UIDevice.isProMax ? 50 : 45)
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
            .font(UIDevice.isProMax ? .callout : .footnote)
            .padding(15)
            .background(.signInTextField)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

extension UIDevice {
    static var isProMax: Bool {
        guard let screen = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.screen
        else {
            return false
        }

        return screen.nativeBounds.height >= 2796
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

