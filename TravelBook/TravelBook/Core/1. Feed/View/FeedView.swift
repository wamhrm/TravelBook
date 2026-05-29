//
//  MainView.swift
//  TravelBook
//
//  Created by ddorsat on 01.01.2026.
//

import SwiftUI

struct FeedView: View {
    @ObservedObject var vm: FeedViewModel

    private let authService: any AuthServiceProtocol
    private let favoritesService: any FavoritesServiceProtocol

    init(vm: FeedViewModel,
         authService: any AuthServiceProtocol,
         favoritesService: any FavoritesServiceProtocol) {
        self.vm = vm
        self.authService = authService
        self.favoritesService = favoritesService
    }

    var body: some View {
        NavigationStack(path: $vm.feedRoutes) {
            ZStack {
                Components.backgroundColor()

                if vm.feedCells.isEmpty {
                    VStack(spacing: 30) {
                        ProgressView()

                        if vm.isServerWakingUp {
                            VStack(spacing: 20) {
                                Text("Сервер просыпается. Первый запуск может занять до 50 секунд.")
                                    .lineSpacing(3)

                                Text("Пожалуйста, ожидайте.")
                            }
                            .font(.callout)
                            .bold()
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 55)
                            .animation(.easeInOut(duration: 0.25), value: vm.isServerWakingUp)
                        }
                    }
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: Components.displaySize(30, 30, 32)) {
                            VStack(alignment: .leading, spacing: Components.displaySize(10, 10, 12)) {
                                HStack(spacing: 10) {
                                    Image("logo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 38, height: 38)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))

                                    VStack(alignment: .leading, spacing: -1) {
                                        Text("УЧЕБНИК")
                                        Text("ПУТЕШЕСТВИЙ")
                                    }
                                    .font(Components.displaySize(.footnote, .system(size: 13), .system(size: 14)))
                                    .fontDesign(.monospaced)
                                    .fontWeight(.heavy)

                                    Spacer()
                                }

                                FeedHeadView(cell: vm.displayHeadCell) {
                                    vm.feedRoutes.append(.headCell(vm.displayHeadCell))
                                }
                            }
                            .padding(.horizontal)

                            VStack(alignment: .leading, spacing: Components.displaySize(10, 10, 12)) {
                                HStack {
                                    Components.headerView("Популярное")

                                    Spacer()

                                    Button {
                                        vm.feedRoutes.append(.popular)
                                    } label: {
                                        Text("Ещё")
                                            .foregroundStyle(.blue)
                                    }
                                }
                                .padding(.horizontal)

                                ScrollView(.horizontal) {
                                    HStack(spacing: Components.displaySize(10, 10, 12)) {
                                        ForEach(vm.displayPopularCells.prefix(5)) { cell in
                                            FeedPopularCellView(cell: cell) {
                                                vm.feedRoutes.append(.bigCell(cell))
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }

                            VStack(alignment: .leading, spacing: Components.displaySize(10, 10, 12)) {
                                Components.headerView("Лента")

                                LazyVStack(alignment: .leading, spacing: 12) {
                                    ForEach(vm.displayFeedCells) { cell in
                                        CompactCellView(cell: cell) {
                                            vm.feedRoutes.append(.feedCell(cell))
                                        }
                                    }

                                    if !vm.feedCells.isEmpty, vm.canLoadMore {
                                        ProgressView()
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 50)
                                            .onAppear {
                                                vm.fetchMoreCells()
                                            }
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .bottomAreaPadding(15)
                        }
                    }
                }
            }
            .navigationTitle("Лента")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: FeedRoutes.self) { destination in
                destinationView(destination)
            }
            .animation(.easeInOut(duration: 0.25), value: vm.feedCells.isEmpty || vm.isServerWakingUp)
            .refreshable {
                await vm.fetchData()
            }
            .alert(vm.alertMessage, isPresented: $vm.showAlert) {
                Button("OK", role: .cancel) {}
            }
        }
    }
}

extension FeedView {
    @ViewBuilder
    private func destinationView(_ destination: FeedRoutes) -> some View {
        switch destination {
            case .headCell(let cell), .bigCell(let cell),
                 .feedCell(let cell), .cellDetails(let cell):
                CellDetailsView(cell: cell,
                                authService: authService,
                                favoritesService: favoritesService)
            case .popular:
                PopularView(cells: vm.popularCells) { cell in
                    vm.feedRoutes.append(.cellDetails(cell))
                }
        }
    }
}

#Preview {
    let authService = AuthService()
    let contentService = ContentService()
    let favoritesService = FavoritesService(authService: authService)
    let vm = FeedViewModel(contentService: contentService, favoritesService: favoritesService)

    return NavigationStack {
        FeedView(vm: vm, authService: authService, favoritesService: favoritesService)
    }
}
