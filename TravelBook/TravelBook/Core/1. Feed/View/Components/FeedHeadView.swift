//
//  FeedHeadView.swift
//  TravelBook
//
//  Created by ddorsat on 01.01.2026.
//

import SwiftUI
import Kingfisher
import UIKit

struct FeedHeadView: View {
    @Environment(\.colorScheme) var colorScheme
    let cell: CellModel
    let onTapHandler: () -> Void
    
    private var isMock: Bool {
        cell.image.isEmpty
    }
    
    var body: some View {
        Button(action: onTapHandler) {
            ZStack(alignment: .leading) {
                Color.black
                
                if !isMock {
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
                            .font(Components.isProMax(.caption, .caption2))
                            .foregroundStyle(.white)
                            .bold()
                            .padding(Components.isProMax(7, 6))
                            .padding(.horizontal, Components.isProMax(4, 3))
                            .background(.feedBigPopular.opacity(colorScheme == .light ? 0.75 : 0.5))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        Text(cell.title)
                            .font(Components.isProMax(.title2, .title3))
                            .foregroundStyle(.white)
                            .fontWeight(.bold)
                            .lineLimit(3)
                            .multilineTextAlignment(.leading)
                    }
                    
                    Spacer()
                    
                    Components.readingTime(cell, true)
                }
                .padding(20)
            }
            .frame(width: Components.isProMax(407, 370), height: Components.isProMax(252, 215))
            .clipShape(RoundedRectangle(cornerRadius: 15))
        }
    }
}

#Preview {
    FeedHeadView(cell: .mock) {
        
    }
    .padding(.horizontal)
}
