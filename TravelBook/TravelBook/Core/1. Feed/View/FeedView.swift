//
//  MainView.swift
//  TravelBook
//
//  Created by ddorsat on 01.01.2026.
//

import SwiftUI

struct FeedView: View {
    @ObservedObject var vm: FeedViewModel

    let authService: any AuthServiceProtocol
    let favoritesService: any FavoritesServiceProtocol

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

                if vm.cells.isEmpty {
                    ProgressView()
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: UIDevice.isProMax ? 32 : 30) {
                            VStack(alignment: .leading, spacing: UIDevice.isProMax ? 12 : 10) {
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
                                    .font(UIDevice.isProMax ? .system(size: 14) : .footnote)
                                    .fontDesign(.monospaced)
                                    .fontWeight(.heavy)

                                    Spacer()
                                }

                                FeedHeadView(cell: vm.displayHeadCell) {
                                    vm.feedRoutes.append(.headCell(vm.displayHeadCell))
                                }
                            }
                            .padding(.horizontal)

                            VStack(alignment: .leading, spacing: UIDevice.isProMax ? 12 : 10) {
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
                                    HStack(spacing: UIDevice.isProMax ? 12 : 10) {
                                        ForEach(vm.displayPopularCells.prefix(5)) { cell in
                                            FeedPopularCellView(cell: cell) {
                                                vm.feedRoutes.append(.bigCell(cell))
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }

                            VStack(alignment: .leading, spacing: UIDevice.isProMax ? 12 : 10) {
                                Components.headerView("Лента")

                                LazyVStack(alignment: .leading, spacing: 12) {
                                    ForEach(vm.displayFeedCells) { cell in
                                        CompactCellView(cell: cell) {
                                            vm.feedRoutes.append(.feedCell(cell))
                                        }
                                    }

                                    if !vm.cells.isEmpty, vm.canLoadMore {
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
                        }
                    }
                }
            }
            .navigationTitle("Лента")
            .navigationBarTitleDisplayMode(.inline)
            .scrollIndicators(.hidden)
            .bottomAreaPadding()
            .navigationDestination(for: FeedRoutes.self) { destination in
                destinationView(destination)
            }
            .refreshable {
                await vm.fetchData()
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
    let contentService = ContentService()
    let favoritesService = FavoritesService()
    let vm = FeedViewModel(contentService: contentService, favoritesService: favoritesService)

    return NavigationStack {
        FeedView(vm: vm, authService: AuthService(), favoritesService: favoritesService)
    }
}
