//
//  FeedPopularCellView.swift
//  TravelBook
//
//  Created by ddorsat on 01.01.2026.
//

import SwiftUI
import Kingfisher

struct FeedPopularCellView: View {
    @Environment(\.colorScheme) private var colorScheme
    let cell: CellModel
    let onTapHandler: () -> Void

    private var isMock: Bool {
        cell.image.isEmpty
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
                        .frame(height: 140)
                        .clipped()
                } else {
                    Image("test")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 140)
                        .clipped()
                }

                VStack(alignment: .leading, spacing: 12) {
                    Components.categoriesTheme(cell.category, .feed)

                    Text(cell.title)
                        .font(.system(size: 13))
                        .foregroundStyle(.title)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                .padding(.horizontal)

                Spacer()
            }
            .frame(width: 230, height: 250)
            .backgroundWithShape(15)
        }
    }
}



#Preview {
    FeedPopularCellView(cell: .mock) {

    }
}
