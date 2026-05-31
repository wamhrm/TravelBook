//
//  AboutAppView.swift
//  TravelBook
//
//  Created by ddorsat on 03.01.2026.
//

import SwiftUI

struct AboutAppView: View {
    var body: some View {
        ZStack {
            BackgroundView()
            
            ScrollView {
                VStack(spacing: 25) {
                    BigLogo()
                    
                    VStack(spacing: 10) {
                        Text("УЧЕБНИК ПУТЕШЕСТВИЙ")
                            .foregroundStyle(.about)
                            .fontDesign(.monospaced)
                            .fontWeight(.medium)
                        
                        Text("1.0.0")
                            .fontWeight(.semibold)
                    }
                    
                    Spacer()
                }
                .navigationTitle("О приложении")
                .navigationBarTitleDisplayMode(.inline)
                .padding(.top, 25)
            }
        }
    }
}

#Preview {
    NavigationStack {
        AboutAppView()
    }
}
