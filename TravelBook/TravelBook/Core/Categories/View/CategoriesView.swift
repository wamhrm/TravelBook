//
//  CategoriesView.swift
//  TravelBook
//
//  Created by ddorsat on 01.01.2026.
//

import SwiftUI

struct CategoriesView: View {
    let categories: [CategoryModel]
    let onTapHandler: (CategoryModel) -> Void
    
    var body: some View {
        ZStack {
            Components.backgroundColor()
            
            ScrollView {
                VStack(alignment: .leading, spacing: Components.isProMax(10, 8)) {
                    ForEach(categories) { category in
                        CategoriesCellView(category: category,
                                           categoryCellsCount: category.cells.count) {
                            onTapHandler(category)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Категории")
            .bottomAreaPadding()
        }
    }
}

#Preview {
    CategoriesView(categories: CategoryModel.mockArray) { _ in
        
    }
}
