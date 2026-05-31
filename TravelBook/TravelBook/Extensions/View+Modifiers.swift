//
//  View+Extensions.swift
//  TravelBook
//
//  Created by ddorsat on 15.05.2026.
//

import SwiftUI

extension View {
    func bottomAreaPadding(_ value: CGFloat) -> some View {
        self
            .safeAreaInset(edge: .bottom) { Color.clear.frame(height: value) }
    }
    func cellDetailsModifier() -> some View {
        self
            .scaledToFill()
            .frame(width: Adaptive.size(410, 422, 447),
                   height: Adaptive.size(285, 297, 322))
            .clipped()
    }

    func feedHeadCellModifier() -> some View {
        self
            .scaledToFill()
            .frame(width: Adaptive.size(370, 382, 407),
                   height: Adaptive.size(215, 227, 252))
            .clipped()
            .opacity(0.35)
    }

    func searchSmallCategoriesModifier() -> some View {
        self
            .scaledToFill()
            .frame(width: Adaptive.size(45, 46, 50),
                   height: Adaptive.size(45, 46, 50))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .clipped()
    }

    func backgroundWithShape(_ amount: CGFloat) -> some View {
        self
            .background(RoundedRectangle(cornerRadius: amount).fill(.backgroundWithShape))
            .overlay(RoundedRectangle(cornerRadius: amount).stroke(.black, lineWidth: 0.2))
            .clipShape(RoundedRectangle(cornerRadius: amount))
    }

    func logoModifier() -> some View {
        self
            .scaledToFit()
            .frame(width: Adaptive.size(18, 18, 20),
                   height: Adaptive.size(18, 18, 20),
                   alignment: .leading)
            .clipped()
    }
    
    func dismissKeyboardOnTap() -> some View {
        simultaneousGesture(TapGesture().onEnded { _ in
            UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder),
                to: nil,
                from: nil,
                for: nil)
            }
        )
    }
}
