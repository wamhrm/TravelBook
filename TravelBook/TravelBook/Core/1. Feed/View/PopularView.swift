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
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            ScrollView {
                LazyVStack(alignment: .leading, spacing: Adaptive.size(10, 10, 12)) {
                    ForEach(cells) { cell in
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
