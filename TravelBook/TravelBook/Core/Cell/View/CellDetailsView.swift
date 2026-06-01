//
//  CellDetailsView.swift
//  TravelBook
//
//  Created by ddorsat on 02.01.2026.
//

import Combine
import SwiftUI
import Kingfisher

struct CellDetailsView: View {
    @StateObject private var vm: CellDetailsViewModel
    let cell: CellModel

    init(cell: CellModel,
         authService: any AuthServiceProtocol,
         favoritesService: any FavoritesServiceProtocol) {
        self.cell = cell
        _vm = StateObject(wrappedValue: CellDetailsViewModel(cell: cell,
                                                             authService: authService,
                                                             favoritesService: favoritesService))
    }

    var body: some View {
        ZStack {
            BackgroundView()

            ScrollView {
                VStack(spacing: 17) {
                    if !cell.isMock {
                        KFImage(URL(string: cell.image))
                            .resizable()
                            .cellDetailsModifier()

                    } else {
                        Image("test")
                            .resizable()
                            .cellDetailsModifier()
                    }

                    BigCellView(cell: cell, isCellDetails: true, isFavorite: vm.isFavorite) {
                        if case .signedIn = vm.authService.authState.value {
                            withAnimation {
                                vm.isFavorite.toggle()
                            }

                            vm.toggleFavorite()
                        } else {
                            vm.showAlert.toggle()
                        }
                    }
                    .padding(.horizontal, 20)

                    TabView {
                        ForEach(cell.images, id: \.self) { image in
                            KFImage(URL(string: image))
                                .resizable()
                                .scaledToFill()
                                .clipped()
                        }
                    }
                    .frame(height: Adaptive.size(225, 237, 262))
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal, 20)
                }
                .padding(.top, Adaptive.size(-116, -129, -153))
                .bottomAreaPadding(50)
                .alert("Пожалуйста, авторизуйтесь или зарегистрируйтесь",
                       isPresented: $vm.showAlert) {
                    Button("OK", role: .cancel) {}
                }
            }
        }
    }
}

#Preview {
    let authService = AuthService()
    let favoritesService = FavoritesService(authService: authService)

    return NavigationStack {
        CellDetailsView(cell: CellModel.mock,
                        authService: authService,
                        favoritesService: favoritesService)
    }
}
