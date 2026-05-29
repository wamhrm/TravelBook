//
//  SearchPopularCellView.swift
//  TravelBook
//
//  Created by ddorsat on 03.05.2026.
//

import SwiftUI

struct SearchPopularRequestCellView: View {
    let request: String
    let onTapHandler: () -> Void

    var body: some View {
        Button {
            onTapHandler()
        } label: {
            Text(request)
                .foregroundStyle(.blackAndWhite)
                .font(Components.displaySize(.caption, .footnote, .footnote))
                .fontWeight(.medium)
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
                .lineLimit(1)
                .backgroundWithShape(25)
        }
    }
}

#Preview {
    SearchPopularRequestCellView(request: "Поезда на Бали") {

    }
}
