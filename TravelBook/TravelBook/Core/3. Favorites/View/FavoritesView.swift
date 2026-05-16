//
//  FavoritesView.swift
//  TravelBook
//
//  Created by ddorsat on 01.01.2026.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var vm: FavoritesViewModel

    init(vm: FavoritesViewModel) {
        self.vm = vm
    }

    var body: some View {
        NavigationStack(path: $vm.favoritesRoutes) {
            ZStack {
                Components.backgroundColor()

                if vm.favoriteCells.isEmpty {
                    ContentUnavailableView {
                        Label("Нет избранного", systemImage: "heart")
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: Components.isProMax(12, 10)) {
                            ForEach(vm.favoriteCells) { cell in
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
                                authService: vm.cellDetailsAuthService,
                                favoritesService: vm.cellDetailsFavoritesService)
        }
    }
}

#Preview {
    let authService = AuthService()
    let favoritesService = FavoritesService(authService: authService)
    let vm = FavoritesViewModel(authService: authService, favoritesService: favoritesService)

    return FavoritesView(vm: vm)
}
