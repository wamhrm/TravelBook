//
//  FeedPopularCellView.swift
//  TravelBook
//
//  Created by ddorsat on 01.01.2026.
//

import SwiftUI
import Kingfisher

struct FeedPopularCellView: View {
    let cell: CellModel
    let onTapHandler: () -> Void

    var body: some View {
        Button(action: onTapHandler) {
            VStack(alignment: .leading, spacing: 15) {
                if !cell.isMock {
                    KFImage(URL(string: cell.image))
                        .placeholder {
                            ProgressView()
                        }
                        .resizable()
                        .frame(height: Adaptive.size(140, 152, 177))
                        .clipped()
                } else {
                    Image("test")
                        .resizable()
                        .scaledToFill()
                        .frame(height: Adaptive.size(140, 152, 177))
                        .clipped()
                }

                VStack(alignment: .leading, spacing: 12) {
                    CategoryThemeLabel(category: cell.category, size: .feed)

                    Text(cell.title)
                        .font(.system(size: Adaptive.size(13, 13, 14)))
                        .foregroundStyle(.title)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                .padding(.horizontal)

                Spacer()
            }
            .frame(width: Adaptive.size(230, 242, 267),
                   height: Adaptive.size(250, 262, 287))
            .backgroundWithShape(15)
        }
    }
}

#Preview {
    FeedPopularCellView(cell: CellModel.mock) {

    }
}
