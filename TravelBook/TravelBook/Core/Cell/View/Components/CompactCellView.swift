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
            VStack(alignment: .leading, spacing: Adaptive.size(15, 15, 17)) {
                CategoryThemeLabel(category: cell.category, size: .feed)

                Text(cell.title)
                    .foregroundStyle(.blackAndWhite)
                    .lineLimit(2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)

                Text(cell.description)
                    .font(Adaptive.size(.footnote, .system(size: 13), .system(size: 14)))
                    .foregroundStyle(.deepGray)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)

                ReadingTimeLabel(cell: cell, isFeed: false)
            }
            .padding(15)
            .frame(maxWidth: .infinity, maxHeight: Adaptive.size(225, 237, 262))
            .backgroundWithShape(15)
        }
    }
}

#Preview {
    VStack {
        CompactCellView(cell: CellModel.mock) {

        }

        CompactCellView(cell: CellModel.mock) {

        }
    }
}
