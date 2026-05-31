//
//  Components.swift
//  TravelBook
//
//  Created by ddorsat on 02.01.2026.
//

import SwiftUI

struct HeaderView: View {
    private let title: String

    init(_ title: String) {
        self.title = title
    }

    var body: some View {
        Text(title)
            .font(.title3)
            .fontWeight(.semibold)
            .padding(.leading, 4)
    }
}

struct BigLogo: View {
    var body: some View {
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
}

struct BackgroundView: View {
    var body: some View {
        Color(uiColor: .background).ignoresSafeArea()
    }
}

struct CategoryThemeLabel: View {
    let category: Categories
    let size: CategoriesThemeSizes

    var body: some View {
        Text(category.title)
            .font(size.font)
            .foregroundStyle(category.color)
            .fontWeight(.medium)
            .padding(5)
            .padding(.horizontal, 5)
            .background(category.color.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

struct ReadingTimeLabel: View {
    let cell: CellModel
    let isFeed: Bool

    var body: some View {
        HStack {
            Image(systemName: "clock")

            Text("\(cell.readingTime) мин чтения")
        }
        .font(Adaptive.size(isFeed ? .footnote : .caption,
                            isFeed ? .footnote : .caption,
                            isFeed ? .footnote : .caption2))
        .fontWeight(.semibold)
        .foregroundStyle(isFeed ? .readingTimeTrue : .readingTimeFalse)
    }
}

enum CategoriesThemeSizes {
    case feed, search

    var font: Font {
        switch self {
            case .feed: .caption
            case .search: .footnote
        }
    }
}
