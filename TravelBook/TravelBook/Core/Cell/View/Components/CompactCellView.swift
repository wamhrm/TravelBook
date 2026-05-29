//
//  FeedCellView.swift
//  TravelBook
//
//  Created by ddorsat on 01.01.2026.
//

import SwiftUI
import Kingfisher

struct CompactCellView: View {
    let cell: CellModel
    let onTapHandler: () -> Void

    var body: some View {
        Button(action: onTapHandler) {
            VStack(alignment: .leading, spacing: Components.displaySize(15, 15, 17)) {
                Components.categoriesTheme(cell.category, .feed)

                Text(cell.title)
                    .foregroundStyle(.blackAndWhite)
                    .lineLimit(2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)

                Text(cell.description)
                    .font(Components.displaySize(.footnote, .system(size: 13), .system(size: 14)))
                    .foregroundStyle(.deepGray)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)

                Components.readingTime(cell, false)
            }
            .padding(15)
            .frame(maxWidth: .infinity, maxHeight: Components.displaySize(225, 237, 262))
            .backgroundWithShape(15)
        }
    }
}

#Preview {
    VStack {
        CompactCellView(cell: .mock) {

        }

        CompactCellView(cell: .mock) {

        }
    }
}
