//
//  CellBuilderView.swift
//  TravelBook
//
//  Created by ddorsat on 04.01.2026.
//

import SwiftUI

struct BigCellView: View {
    let cell: CellModel
    let isCellDetails: Bool
    @Binding private var isFavorite: Bool
    private var onFavoriteTapHandler: (() -> Void)?

    init(cell: CellModel,
         isCellDetails: Bool,
         isFavorite: Binding<Bool> = .constant(false),
         onFavoriteTapHandler: (() -> Void)? = nil) {
        self.cell = cell
        self.isCellDetails = isCellDetails
        self._isFavorite = isFavorite
        self.onFavoriteTapHandler = onFavoriteTapHandler
    }

    var body: some View {
        VStack(alignment: .leading, spacing: isCellDetails ? Adaptive.size(8, 8, 10) : Adaptive.size(6, 6, 8)) {
            if !isCellDetails {
                CategoryThemeLabel(category: cell.category, size: .search)
            }

            VStack(alignment: .leading, spacing: isCellDetails ? 12 : 10) {
                Text(cell.title)
                    .font(isCellDetails ? .title2 : .default)
                    .fontWeight(.semibold)
                    .foregroundStyle(.title)
                    .lineLimit(isCellDetails ? .max : 2)
                    .multilineTextAlignment(.leading)

                Text(cell.subtitle)
                    .font(isCellDetails ? Adaptive.size(.system(size: 14), .system(size: 15), .default) : Adaptive.size(.footnote, .system(size: 13), .system(size: 14)))
                    .foregroundStyle(.subtitle)
                    .lineLimit(isCellDetails ? .max : 2)
                    .multilineTextAlignment(.leading)

                HStack(spacing: isCellDetails ? 15 : 10) {
                    Text(cell.dateString)

                    Rectangle()
                        .foregroundStyle(.cellDivider)
                        .frame(width: 1, height: Adaptive.size(13, 13, 15))

                    Text("\(cell.readingTime) мин")

                    if isCellDetails {
                        Rectangle()
                            .foregroundStyle(.cellDivider)
                            .frame(width: 1, height: Adaptive.size(13, 13, 15))

                        Button {
                            withAnimation {
                                isFavorite.toggle()
                            }

                            onFavoriteTapHandler?()
                        } label: {
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                                .imageScale(.large)
                                .foregroundStyle(isFavorite ? .red : .gray)
                        }
                    }
                }
                .font(isCellDetails ? Adaptive.size(.footnote, .system(size: 13), .system(size: 14))
                                    : Adaptive.size(.caption, .footnote, .footnote))
                .foregroundStyle(.subtitle)
            }
            .padding(.top, 7)

            Text(cell.description)
                .font(isCellDetails ? Adaptive.size(.system(size: 14), .system(size: 15), .callout)
                                    : Adaptive.size(.footnote, .system(size: 14), .callout))
                .foregroundStyle(.description)
                .lineSpacing(6)
                .padding(.vertical, 10)
                .lineLimit(isCellDetails ? .max : 3)

            if !isCellDetails {
                Text("Читать далее")
                    .font(.subheadline)
                    .foregroundStyle(.blue)
                    .padding(.bottom, 5)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .multilineTextAlignment(.leading)
    }
}

#Preview {
    BigCellView(cell: CellModel.mock, isCellDetails: true)
}
