//
//  FavoritesView.swift
//  TravelBook
//
//  Created by ddorsat on 01.01.2026.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var vm: FavoritesViewModel

    let authService: any AuthServiceProtocol
    let favoritesService: any FavoritesServiceProtocol

    init(vm: FavoritesViewModel,
         authService: any AuthServiceProtocol,
         favoritesService: any FavoritesServiceProtocol) {
        self.vm = vm
        self.authService = authService
        self.favoritesService = favoritesService
    }

    var body: some View {
        NavigationStack(path: $vm.favoritesRoutes) {
            ZStack {
                Components.backgroundColor()

                if vm.favorites.isEmpty {
                    ContentUnavailableView {
                        Label("Нет избранного", systemImage: "heart")
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 15) {
                            ForEach(vm.favorites) { cell in
                                CompactCellView(cell: cell) {
                                    vm.favoritesRoutes.append(.cellDetails(cell))
                                }
                                .contextMenu {
                                    Button {
                                        withAnimation(.spring) {
                                            vm.removeFromFavorites(cell: cell)
                                        }
                                    } label: {
                                        Text("Удалить")
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Избранное")
            .navigationBarTitleDisplayMode(.inline)
            .bottomAreaPadding()
            .navigationDestination(for: FavoritesRoutes.self) { destination in
                destinationView(destination)
            }
            .refreshable {
                vm.fetchFavorites()
            }
        }
    }
}

extension FavoritesView {
    @ViewBuilder
    private func destinationView(_ route: FavoritesRoutes) -> some View {
        switch route {
            case .cellDetails(let cell):
                CellDetailsView(cell: cell,
                                authService: authService,
                                favoritesService: vm.favoritesService)
        }
    }
}

#Preview {
    let authService = AuthService()
    let favoritesService = FavoritesService()
    let vm = FavoritesViewModel(authService: authService, favoritesService: favoritesService)
    
    return FavoritesView(vm: vm, authService: authService, favoritesService: favoritesService)
}
