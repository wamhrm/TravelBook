//
//  PopularView.swift
//  TravelBook
//
//  Created by ddorsat on 05.01.2026.
//

import SwiftUI

struct PopularView: View {
    let cells: [CellModel]
    let onTapHandler: (CellModel) -> Void
    
    private var displayCells: [CellModel] {
        return !cells.isEmpty ? cells : CellModel.mockArray
    }
    
    var body: some View {
        ZStack {
            Components.backgroundColor()
            
            ScrollView {
                LazyVStack(alignment: .leading, spacing: Components.displaySize(10, 10, 12)) {
                    ForEach(displayCells) { cell in
                        CompactCellView(cell: cell) {
                            onTapHandler(cell)
                        }
                    }
                }
                .padding(.horizontal)
                .bottomAreaPadding(15)
            }
        }
        .navigationTitle("Популярное")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    PopularView(cells: CellModel.mockArray) { _ in
        
    }
}
