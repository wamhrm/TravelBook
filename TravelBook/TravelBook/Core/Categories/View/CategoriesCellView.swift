//
//  TrendingCellView.swift
//  TravelBook
//
//  Created by ddorsat on 03.01.2026.
//

import SwiftUI
import Kingfisher

struct CategoriesCellView: View {
    let category: CategoryModel
    let categoryCellsCount: Int
    let onTapHandler: () -> Void
    
    private var displayCategories: Bool {
        category.image.isEmpty
    }
    
    var body: some View {
        Button(action: onTapHandler) {
            HStack(alignment: .center, spacing: 15) {
                if !displayCategories {
                    KFImage(URL(string: category.image))
                        .placeholder {
                            ProgressView()
                        }
                        .resizable()
                        .searchSmallCategoriesModifier()
                } else {
                    Image("test")
                        .resizable()
                        .searchSmallCategoriesModifier()
                }
                    
                VStack(alignment: .leading, spacing: 7) {
                    Text(category.type.title)
                        .foregroundStyle(.blackAndWhite)
                        .font(.callout)
                        .bold()
                    
                    if categoryCellsCount == 0 {
                        Text("Пока нет статей")
                            .font(.footnote)
                            .foregroundStyle(.gray)
                    } else {
                        Text("\(categoryCellsCount) статей")
                            .font(.caption)
                            .foregroundStyle(.gray)
                            .fontWeight(.medium)
                    }
                }
                
                Spacer()
                
                Text("Перейти")
                    .foregroundStyle(.title)
                    .font(.system(size: 14))
                    .fontWeight(.semibold)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(.categoriesCellBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            }
            .padding(12)
            .backgroundWithShape(12)
        }
    }
}

#Preview {
    CategoriesCellView(category: .mock, categoryCellsCount: 5) {
        
    }
}
