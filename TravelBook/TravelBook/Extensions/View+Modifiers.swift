//
//  View+Extensions.swift
//  TravelBook
//
//  Created by ddorsat on 15.05.2026.
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
            .frame(width: Components.isProMax(447, 410), height: Components.isProMax(322, 285))
            .clipped()
    }

    func feedHeadCellModifier() -> some View {
        self
            .scaledToFill()
            .frame(width: Components.isProMax(407, 370), height: Components.isProMax(252, 215))
            .clipped()
            .opacity(0.35)
    }

    func searchSmallCategoriesModifier() -> some View {
        self
            .scaledToFill()
            .frame(width: Components.isProMax(50, 45), height: Components.isProMax(50, 45))
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
            .font(Components.isProMax(.callout, .footnote))
            .frame(maxWidth: .infinity)
            .frame(height: Components.isProMax(22, 20))
            .padding(15)
            .background(.signInTextField)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    func logoModifier() -> some View {
        self
            .scaledToFit()
            .frame(width: Components.isProMax(20, 18), height: Components.isProMax(20, 18), alignment: .leading)
            .clipped()
    }
}
