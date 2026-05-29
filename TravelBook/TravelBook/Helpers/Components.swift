//
//  Components.swift
//  TravelBook
//
//  Created by ddorsat on 02.01.2026.
//

import SwiftUI

struct Components {
    static func headerView(_ title: String) -> some View {
        Text(title)
            .font(.title3)
            .fontWeight(.semibold)
            .padding(.leading, 4)
    }

    static func bigLogo() -> some View {
        Image("logo")
            .resizable()
            .scaledToFit()
            .frame(width: 65, height: 65)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 1)
                    .foregroundStyle(Color(uiColor: .systemGray3))
            }
    }

    static func categoriesTheme(_ category: Categories, _ size: CategoriesThemeSizes) -> some View {
        Text(category.title)
            .font(size.font)
            .foregroundStyle(category.color)
            .fontWeight(.medium)
            .padding(5)
            .padding(.horizontal, 5)
            .background(category.color.opacity(0.120))
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }

    static func backgroundColor() -> some View {
        return Color(uiColor: .background).ignoresSafeArea()
    }

    static func readingTime(_ cell: CellModel, _ isFeed: Bool) -> some View {
        HStack {
            Image(systemName: "clock")

            Text("\(cell.readingTime) мин чтения")
        }
        .font(displaySize(isFeed ? .footnote : .caption,
                        isFeed ? .footnote : .caption,
                        isFeed ? .footnote : .caption2))
        .fontWeight(.semibold)
        .foregroundStyle(isFeed ? .readingTimeTrue : .readingTimeFalse)
    }

    static func displaySize<T>(_ base: T, _ air: T, _ plus: T) -> T {
        switch UIDevice.screenSizeClass {
            case .base:
                return base
            case .air:
                return air
            case .plus:
                return plus
        }
    }
}

enum CategoriesThemeSizes {
    case feed, search

    var font: Font {
        switch self {
            case .feed:
                return .caption
            case .search:
                return .footnote
        }
    }
}
