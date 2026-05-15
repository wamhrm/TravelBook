//
//  CellCategoriesView.swift
//  TravelBook
//
//  Created by ddorsat on 05.01.2026.
//

import SwiftUI

struct CategoryCellsView: View {
    @ObservedObject var vm: SearchViewModel
    let category: CategoryModel
    let onTapHandler: (CellModel) -> Void

    var body: some View {
        ZStack {
            Components.backgroundColor()

            ScrollView {
                ForEach(vm.displayCategoryResults) { cell in
                    CompactCellView(cell: cell) {
                        vm.searchRoutes.append(.categoryCellDetails(cell))
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle(category.type.title)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            vm.selectCategory(category.type)
        }
        .bottomAreaPadding()
    }
}

#Preview {
    NavigationStack {
        CategoryCellsView(vm: SearchViewModel(contentService: ContentService()), category: .mock) { _ in

        }
    }
}
