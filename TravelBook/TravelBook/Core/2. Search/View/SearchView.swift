//
//  SearchView.swift
//  TravelBook
//
//  Created by ddorsat on 01.01.2026.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var vm: SearchViewModel

    let authService: any AuthServiceProtocol
    let favoritesService: any FavoritesServiceProtocol

    var body: some View {
        NavigationStack(path: $vm.searchRoutes) {
            ZStack {
                BackgroundView()

                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {
                        VStack(alignment: .leading, spacing: Adaptive.size(12, 12, 14)) {
                            HeaderView("Популярные запросы")

                            FlowLayout(spacing: 5) {
                                ForEach(vm.popularRequests, id: \.self) { request in
                                    SearchPopularRequestCellView(request: request) {
                                        vm.requestToSearch(request)
                                    }
                                }
                            }
                        }
                        .padding(.top, 5)
                        .padding(.horizontal)

                        VStack(alignment: .leading, spacing: Adaptive.size(10, 10, 12)) {
                            HStack {
                                HeaderView("Категории")

                                Spacer()

                                Button {
                                    vm.searchRoutes.append(.categories)
                                } label: {
                                    Text("Ещё")
                                        .foregroundStyle(.blue)
                                }
                            }

                            VStack(alignment: .leading, spacing: Adaptive.size(7, 7, 8)) {
                                ForEach(vm.categories.prefix(3)) { category in
                                    CategoriesCellView(category: category,
                                                       categoryCellsCount: category.cells.count) {
                                        vm.searchRoutes.append(.categoryCells(category))
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)

                        VStack(alignment: .leading, spacing: Adaptive.size(10, 10, 12)) {
                            HeaderView("Посты")

                            LazyVStack(alignment: .leading, spacing: Adaptive.size(10, 10, 12)) {
                                ForEach(vm.cells) { cell in
                                    BigCellView(cell: cell, isCellDetails: false)
                                        .padding()
                                        .backgroundWithShape(20)
                                        .onTapGesture {
                                            vm.searchRoutes.append(.searchFeedCellDetails(cell))
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
                        .bottomAreaPadding(15)
                    }
                }
            }
            .navigationTitle("Поиск")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: SearchRoutes.self, destination: destinationView)
            .searchable(text: $vm.searchText,
                        placement: .navigationBarDrawer(displayMode: .automatic),
                        prompt: "Поиск")
            .onSubmit(of: .search) {
                Task { await vm.searchData() }
            }
            .refreshable {
                vm.refreshData()
            }
            .alert(vm.alertMessage, isPresented: $vm.showAlert) {
                Button("OK", role: .cancel) {}
            }
        }
    }
}

extension SearchView {
    @ViewBuilder
    private func destinationView(_ destination: SearchRoutes) -> some View {
        switch destination {
            case .searchResults:
                SearchResultsView(vm: vm)
            case .searchResultsCellDetails(let cell),
                 .searchFeedCellDetails(let cell),
                 .categoryCellDetails(let cell):
                CellDetailsView(cell: cell,
                                authService: authService,
                                favoritesService: favoritesService)
            case .categories:
                CategoriesView(categories: vm.categories) { category in
                    vm.searchRoutes.append(.categoryCells(category))
                }
            case .categoryCells(let category):
                CategoryCellsView(vm: vm, category: category)
        }
    }
}

#Preview {
    let contentService = ContentService()
    let vm = SearchViewModel(contentService: contentService)

    let authService = AuthService()
    let favoritesService = FavoritesService(authService: authService)

    return NavigationStack {
        SearchView(vm: vm, authService: authService, favoritesService: favoritesService)
    }
}
