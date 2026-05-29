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

    private var isMock: Bool {
        return cell.image.isEmpty
    }

    var body: some View {
        Button(action: onTapHandler) {
            VStack(alignment: .leading, spacing: 15) {
                if !isMock {
                    KFImage(URL(string: cell.image))
                        .placeholder {
                            ProgressView()
                        }
                        .resizable()
                        .frame(height: Components.displaySize(140, 152, 177))
                        .clipped()
                } else {
                    Image("test")
                        .resizable()
                        .scaledToFill()
                        .frame(height: Components.displaySize(140, 152, 177))
                        .clipped()
                }

                VStack(alignment: .leading, spacing: 12) {
                    Components.categoriesTheme(cell.category, .feed)

                    Text(cell.title)
                        .font(.system(size: Components.displaySize(13, 13, 14)))
                        .foregroundStyle(.title)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                .padding(.horizontal)

                Spacer()
            }
            .frame(width: Components.displaySize(230, 242, 267), height: Components.displaySize(250, 262, 287))
            .backgroundWithShape(15)
        }
    }
}



#Preview {
    FeedPopularCellView(cell: .mock) {

    }
}
