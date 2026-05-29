//
//  SearchResultsView.swift
//  TravelBook
//
//  Created by ddorsat on 05.01.2026.
//

import SwiftUI

struct SearchResultsView: View {
    @ObservedObject var vm: SearchViewModel
    let onTapHandler: (CellModel) -> Void

    var body: some View {
        ZStack {
            Components.backgroundColor()

            if vm.searchResults.isEmpty {
                ContentUnavailableView {
                    Label("Ничего не найдено", systemImage: "magnifyingglass")
                }
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: Components.displaySize(10, 10, 12)) {
                        ForEach(vm.searchResults) { cell in
                            CompactCellView(cell: cell) {
                                onTapHandler(cell)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .bottomAreaPadding(15)
                }
            }
        }
        .navigationTitle("Поиск")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SearchResultsView(vm: SearchViewModel(contentService: ContentService())) { _ in

        }
    }
}
