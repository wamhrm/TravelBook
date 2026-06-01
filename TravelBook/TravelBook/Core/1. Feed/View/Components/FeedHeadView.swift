//
//  FeedHeadView.swift
//  TravelBook
//
//  Created by ddorsat on 01.01.2026.
//

import SwiftUI
import Kingfisher

struct FeedHeadView: View {
    @Environment(\.colorScheme) var colorScheme
    let cell: CellModel
    let onTapHandler: () -> Void

    var body: some View {
        Button(action: onTapHandler) {
            ZStack(alignment: .leading) {
                Color.black
                
                if !cell.isMock {
                    KFImage(URL(string: cell.image))
                        .placeholder {
                            ProgressView()
                        }
                        .resizable()
                        .feedHeadCellModifier()
                } else {
                    Image("test")
                        .resizable()
                        .feedHeadCellModifier()
                }
                
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("УЧЕБНИК")
                            .font(Adaptive.size(.caption2, .caption, .caption))
                            .foregroundStyle(.white)
                            .bold()
                            .padding(Adaptive.size(6, 6, 7))
                            .padding(.horizontal, Adaptive.size(3, 3, 4))
                            .background(.feedBigPopular.opacity(colorScheme == .light ? 0.75 : 0.5))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        Text(cell.title)
                            .font(Adaptive.size(.title3, .system(size: 21), .title2))
                            .foregroundStyle(.white)
                            .fontWeight(.bold)
                            .lineLimit(3)
                            .multilineTextAlignment(.leading)
                    }
                    
                    Spacer()
                    
                    ReadingTimeLabel(cell: cell, isFeed: true)
                }
                .padding(20)
            }
            .frame(width: Adaptive.size(372, 391, 410),
                   height: Adaptive.size(215, 227, 252))
            .clipShape(RoundedRectangle(cornerRadius: 15))
        }
    }
}

#Preview {
    FeedHeadView(cell: CellModel.mock) {
        
    }
    .padding(.horizontal)
}
