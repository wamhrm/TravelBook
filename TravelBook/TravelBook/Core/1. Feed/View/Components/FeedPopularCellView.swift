//
//  FeedPopularCellView.swift
//  TravelBook
//
//  Created by ddorsat on 01.01.2026.
//

import SwiftUI
import Kingfisher
import UIKit

struct FeedPopularCellView: View {
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
                        .frame(height: Components.isProMax(177, 140))
                        .clipped()
                } else {
                    Image("test")
                        .resizable()
                        .scaledToFill()
                        .frame(height: Components.isProMax(177, 140))
                        .clipped()
                }

                VStack(alignment: .leading, spacing: 12) {
                    Components.categoriesTheme(cell.category, .feed)

                    Text(cell.title)
                        .font(.system(size: Components.isProMax(14, 13)))
                        .foregroundStyle(.title)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                .padding(.horizontal)

                Spacer()
            }
            .frame(width: Components.isProMax(267, 230), height: Components.isProMax(287, 250))
            .backgroundWithShape(15)
        }
    }
}



#Preview {
    FeedPopularCellView(cell: .mock) {

    }
}
