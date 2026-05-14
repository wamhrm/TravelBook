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
                        .font(UIDevice.isProMax ? .callout : .footnote)
                        .bold()
                    
                    if categoryCellsCount == 0 {
                        Text("Пока нет статей")
                            .font(.footnote)
                            .foregroundStyle(.gray)
                    } else {
                        Text(articlesCountLabel)
                            .font(UIDevice.isProMax ? .caption : .caption2)
                            .foregroundStyle(.gray)
                            .fontWeight(.medium)
                    }
                }
                
                Spacer()
                
                Text("Перейти")
                    .foregroundStyle(.title)
                    .font(.system(size: UIDevice.isProMax ? 14 : 12))
                    .fontWeight(.semibold)
                    .padding(.vertical, UIDevice.isProMax ? 8 : 6)
                    .padding(.horizontal, UIDevice.isProMax ? 12 : 10)
                    .background(.categoriesCellBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            }
            .padding(12)
            .backgroundWithShape(12)
        }
    }
}

extension CategoriesCellView {
    private var articlesCountLabel: String {
        let n = categoryCellsCount
        let mod10 = n % 10
        let mod100 = n % 100
        let word: String
        
        if mod10 == 1, mod100 != 11 {
            word = "статья"
        } else if (2...4).contains(mod10), !(12...14).contains(mod100) {
            word = "статьи"
        } else {
            word = "статей"
        }
        
        return "\(n) \(word)"
    }
}

#Preview {
    CategoriesCellView(category: .mock, categoryCellsCount: 5) {
        
    }
}
