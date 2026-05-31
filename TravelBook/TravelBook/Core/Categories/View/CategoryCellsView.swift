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
            BackgroundView()

            ScrollView {
                ForEach(category.cells) { cell in
                    CompactCellView(cell: cell) {
                        vm.searchRoutes.append(.categoryCellDetails(cell))
                    }
                }
                .padding(.horizontal)
                .bottomAreaPadding(15)
            }
        }
        .navigationTitle(category.type.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if category.cells.isEmpty {
                vm.selectCategory(category.type)
            }
        }
    }
}

#Preview {
    NavigationStack {
        CategoryCellsView(vm: SearchViewModel(contentService: ContentService()), category: .mock) { _ in

        }
    }
}
