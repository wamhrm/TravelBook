//
//  FavoritesView.swift
//  TravelBook
//
//  Created by ddorsat on 01.01.2026.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var vm: FavoritesViewModel

    var body: some View {
        NavigationStack(path: $vm.favoritesRoutes) {
            ZStack {
                BackgroundView()

                if vm.isSignedOut {
                    ContentUnavailableView {
                        Label("Войдите, чтобы добавлять в избранное", systemImage: "")
                    }
                } else {
                    if vm.favoriteCells.isEmpty {
                        ContentUnavailableView {
                            Label("Нет избранного", systemImage: "heart")
                        }
                    } else {
                        ScrollView {
                            LazyVStack(spacing: Adaptive.size(10, 10, 12)) {
                                ForEach(vm.favoriteCells) { cell in
                                    CompactCellView(cell: cell) {
                                        vm.favoritesRoutes.append(.cellDetails(cell))
                                    }
                                    .contextMenu {
                                        contextView(cell)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .bottomAreaPadding(15)
                        }
                    }
                }
            }
            .navigationTitle("Избранное")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: FavoritesRoutes.self) { destination in
                destinationView(destination)
            }
            .refreshable {
                await vm.fetchFavorites()
            }
            .alert(vm.alertMessage, isPresented: $vm.showAlert) {
                Button("OK", role: .cancel) {}
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
                                authService: vm.authService,
                                favoritesService: vm.favoritesService)
        }
    }
    
    private func contextView(_ cell: CellModel) -> some View {
        Button {
            withAnimation(.spring) {
                vm.removeFromFavorites(cell: cell)
            }
        } label: {
            Text("Удалить")
        }
    }
}

#Preview {
    let authService = AuthService()
    let favoritesService = FavoritesService(authService: authService)
    let vm = FavoritesViewModel(authService: authService, favoritesService: favoritesService)

    return FavoritesView(vm: vm)
}
