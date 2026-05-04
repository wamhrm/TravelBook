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
        !cells.isEmpty ? cells : CellModel.mockArray
    }
    
    var body: some View {
        ZStack {
            Components.backgroundColor()
            
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 15) {
                    ForEach(displayCells) { cell in
                        CompactCellView(cell: cell) {
                            onTapHandler(cell)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Популярное")
        .navigationBarTitleDisplayMode(.inline)
        .scrollIndicators(.hidden)
    }
}

#Preview {
    PopularView(cells: CellModel.mockArray) { _ in
        
    }
}
