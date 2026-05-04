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
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text(cell.subtitle)
                    .font(isCellDetails ? .callout : .footnote)
                    .foregroundStyle(.subtitle)
                    .fontWeight(.medium)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                HStack(spacing: isCellDetails ? 15 : 10) {
                    Text("\(cell.dateString)")
                        .font(isCellDetails ? .default : .footnote)
                    
                    Rectangle()
                        .foregroundStyle(.cellDivider)
                        .frame(width: 1, height: 15)
                    
                    Text("\(cell.readingTime) мин")
                        .font(isCellDetails ? .default : .footnote)
                    
                    if isCellDetails {
                        Rectangle()
                            .foregroundStyle(.cellDivider)
                            .frame(width: 1, height: 17)
                        
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
                .foregroundStyle(.subtitle)
                .font(.subheadline)
                .fontWeight(.medium)
            }
            .padding(.top, 7)
            
            Text(cell.description)
                .font(isCellDetails ? .callout : .footnote)
                .foregroundStyle(.subtitle)
                .fontWeight(.medium)
                .lineSpacing(6)
                .padding(.vertical, 10)
                .lineLimit(!isCellDetails ? 3 : .max)
            
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
