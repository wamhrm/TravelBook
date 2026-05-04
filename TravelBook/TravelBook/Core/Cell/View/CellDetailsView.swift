//
//  CellDetailsView.swift
//  TravelBook
//
//  Created by ddorsat on 02.01.2026.
//

import SwiftUI
import Combine
import Kingfisher

struct CellDetailsView: View {
    @StateObject private var vm: CellDetailsViewModel
    @State private var showAuthAlert = false
    let cell: CellModel
    let authService: any AuthServiceProtocol

    private var isMock: Bool {
        cell.image.isEmpty
    }

    init(cell: CellModel,
         authService: any AuthServiceProtocol,
         favoritesService: any FavoritesServiceProtocol) {
        self.cell = cell
        self.authService = authService
        _vm = StateObject(wrappedValue: CellDetailsViewModel(cell: cell, favoritesService: favoritesService))
    }

    var body: some View {
        ZStack {
            Components.backgroundColor()
            
            ScrollView {
                VStack(spacing: 17) {
                    if !isMock {
                        KFImage(URL(string: cell.image))
                            .resizable()
                            .cellDetailsModifier()

                    } else {
                        Image("test")
                            .resizable()
                            .cellDetailsModifier()
                    }
                    
                    BigCellView(cell: cell, isCellDetails: true, isFavorite: $vm.isFavorite) {
                        if case .signedIn = authService.authState.value {
                            vm.toggleFavorite()
                        } else {
                            withAnimation {
                                vm.isFavorite.toggle()
                            }

                            showAuthAlert = true
                        }
                    }
                    .padding(.horizontal, 20)

                    TabView {
                        if !isMock {
                            ForEach(cell.images, id: \.self) { image in
                                KFImage(URL(string: image))
                                    .resizable()
                                    .scaledToFill()
                                    .clipped()
                            }
                        } else {
                            ForEach(CellModel.mockArray.prefix(3)) { cell in
                                Image("test")
                                    .resizable()
                                    .scaledToFill()
                                    .clipped()
                            }
                        }
                    }
                    .frame(height: 225)
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal, 20)
                }
                .bottomAreaPadding()
                .alert("Пожалуйста, авторизуйтесь или зарегистрируйтесь", isPresented: $showAuthAlert) {
                    Button("OK", role: .cancel) {}
                }
                .padding(.top, -116)
            }
        }
    }
}

#Preview {
    NavigationStack {
        CellDetailsView(cell: .mock,
                        authService: AuthService(),
                        favoritesService: FavoritesService())
    }
}
