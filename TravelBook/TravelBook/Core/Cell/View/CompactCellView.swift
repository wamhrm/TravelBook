//
//  FeedCellView.swift
//  TravelBook
//
//  Created by ddorsat on 01.01.2026.
//

import SwiftUI
import Kingfisher
import UIKit

struct CompactCellView: View {
    let cell: CellModel
    let onTapHandler: () -> Void

    var body: some View {
        Button(action: onTapHandler) {
            VStack(alignment: .leading, spacing: UIDevice.isProMax ? 17 : 15) {
                Components.categoriesTheme(cell.category, .feed)

                Text(cell.title)
                    .foregroundStyle(.blackAndWhite)
                    .lineLimit(2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)

                Text(cell.description)
                    .font(UIDevice.isProMax ? .system(size: 14) : .footnote)
                    .foregroundStyle(.deepGray)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)

                Components.readingTime(cell, false)
            }
            .padding(15)
            .frame(maxWidth: .infinity, maxHeight: UIDevice.isProMax ? 262 : 225)
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
