//
//  Components.swift
//  TravelBook
//
//  Created by ddorsat on 02.01.2026.
//

import Foundation
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
        .font(isFeed ? .footnote : .caption2)
        .fontWeight(.semibold)
        .foregroundStyle(isFeed ? .readingTimeTrue : .readingTimeFalse)
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

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize,
                      subviews: Subviews,
                      cache: inout ()) -> CGSize {
        let width = proposal.width ?? 0
        var x: CGFloat = 0, y: CGFloat = 0, rowHeight: CGFloat = 0

        for view in subviews {
            let size = view.sizeThatFits(.unspecified)

            if x + size.width > width {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }

            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }

        return CGSize(width: width, height: y + rowHeight)
    }

    func placeSubviews(in bounds: CGRect,
                       proposal: ProposedViewSize,
                       subviews: Subviews,
                       cache: inout ()) {
        var x = bounds.minX, y = bounds.minY, rowHeight: CGFloat = 0

        for view in subviews {
            let size = view.sizeThatFits(.unspecified)

            if x + size.width > bounds.maxX {
                x = bounds.minX
                y += rowHeight + spacing
                rowHeight = 0
            }

            view.place(
                at: CGPoint(x: x, y: y),
                proposal: ProposedViewSize(size)
            )

            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}
