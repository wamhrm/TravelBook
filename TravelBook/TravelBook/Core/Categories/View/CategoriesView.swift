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
                LazyVStack(alignment: .leading, spacing: Components.displaySize(8, 8, 10)) {
                    ForEach(categories) { category in
                        CategoriesCellView(category: category,
                                           categoryCellsCount: category.cells.count) {
                            onTapHandler(category)
                        }
                    }
                }
                .padding(.horizontal)
                .bottomAreaPadding(15)
            }
            .navigationTitle("Категории")
        }
    }
}

#Preview {
    CategoriesView(categories: CategoryModel.mockArray) { _ in

    }
}
