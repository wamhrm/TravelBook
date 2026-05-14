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

    init(cell: CellModel, isCellDetails: Bool) {
        self.cell = cell
        self.isCellDetails = isCellDetails
        self._isFavorite = .constant(false)
        self.onFavoriteTapHandler = nil
    }

    init(cell: CellModel, isCellDetails: Bool,
         isFavorite: Binding<Bool>, onFavoriteTapHandler: (() -> Void)?) {
        self.cell = cell
        self.isCellDetails = isCellDetails
        self._isFavorite = isFavorite
        self.onFavoriteTapHandler = onFavoriteTapHandler
    }

    var body: some View {
        VStack(alignment: .leading, spacing: isCellDetails ? 10 : 8) {
            if !isCellDetails {
                Components.categoriesTheme(cell.category, .search)
            }

            VStack(alignment: .leading, spacing: isCellDetails ? 12 : 10) {
                Text(cell.title)
                    .font(isCellDetails ? .title2 : .default)
                    .fontWeight(.semibold)
                    .foregroundStyle(.title)
                    .lineLimit(isCellDetails ? .max : 2)
                    .multilineTextAlignment(.leading)

                Text(cell.subtitle)
                    .font(isCellDetails ? (UIDevice.isProMax ? .default : .system(size: 14)) : (UIDevice.isProMax ? .system(size: 14) : .footnote))
                    .foregroundStyle(.subtitle)
                    .lineLimit(isCellDetails ? .max : 2)
                    .multilineTextAlignment(.leading)

                HStack(spacing: isCellDetails ? 15 : 10) {
                    Text("\(cell.dateString)")

                    Rectangle()
                        .foregroundStyle(.cellDivider)
                        .frame(width: 1, height: UIDevice.isProMax ? 15 : 13)

                    Text("\(cell.readingTime) мин")

                    if isCellDetails {
                        Rectangle()
                            .foregroundStyle(.cellDivider)
                            .frame(width: 1, height: UIDevice.isProMax ? 15 : 13)

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
                .font(isCellDetails ? (UIDevice.isProMax ? .system(size: 14) : .footnote) : (UIDevice.isProMax ? .footnote : .caption))
                .foregroundStyle(.subtitle)
            }
            .padding(.top, 7)

            Text(cell.description)
                .font(isCellDetails ? (UIDevice.isProMax ? .callout : .system(size: 14)) : (UIDevice.isProMax ? .callout : .footnote))
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
    BigCellView(cell: .mock, isCellDetails: true)
}
