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

    init(vm: SearchViewModel,
         authService: any AuthServiceProtocol,
         favoritesService: any FavoritesServiceProtocol) {
        self.vm = vm
        self.authService = authService
        self.favoritesService = favoritesService
    }

    var body: some View {
        NavigationStack(path: $vm.searchRoutes) {
            ZStack {
                Components.backgroundColor()

                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {
                        VStack(alignment: .leading, spacing: 12) {
                            Components.headerView("Популярные запросы")

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

                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Components.headerView("Категории")

                                Spacer()

                                Button {
                                    vm.searchRoutes.append(.categories)
                                } label: {
                                    Text("Ещё")
                                        .foregroundStyle(.blue)
                                }
                            }

                            VStack(alignment: .leading, spacing: 5) {
                                ForEach(vm.displayCategories.prefix(3)) { category in
                                    CategoriesCellView(category: category,
                                                       categoryCellsCount: category.cells.count) {
                                        vm.searchRoutes.append(.categoryCells(category))
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)

                        VStack(alignment: .leading, spacing: 10) {
                            Components.headerView("Посты")

                            LazyVStack(alignment: .leading, spacing: 12) {
                                ForEach(vm.displayCells) { cell in
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
                    }
                }
            }
            .navigationTitle("Поиск")
            .navigationBarTitleDisplayMode(.inline)
            .bottomAreaPadding()
            .scrollIndicators(.hidden)
            .searchable(text: $vm.searchText,
                        placement: .navigationBarDrawer(displayMode: .automatic),
                        prompt: "Поиск")
            .onSubmit(of: .search) {
                Task { await vm.searchData() }
            }
            .navigationDestination(for: SearchRoutes.self, destination: destinationView)
            .refreshable {
                vm.refreshData()
            }
        }
    }
}

extension SearchView {
    @ViewBuilder
    private func destinationView(_ destination: SearchRoutes) -> some View {
        switch destination {
            case .searchResults:
                SearchResultsView(vm: vm) { cell in
                    vm.searchRoutes.append(.searchResultsCellDetails(cell))
                }
            case .searchResultsCellDetails(let cell):
                CellDetailsView(cell: cell,
                                authService: authService,
                                favoritesService: favoritesService)
            case .searchFeedCellDetails(let cell):
                CellDetailsView(cell: cell,
                                authService: authService,
                                favoritesService: favoritesService)
            case .categories:
                CategoriesView(categories: vm.displayCategories) { category in
                    vm.searchRoutes.append(.categoryCells(category))
                }
            case .categoryCells(let category):
                CategoryCellsView(vm: vm, category: category) { cell in
                    vm.searchRoutes.append(.categoryCellDetails(cell))
                }
            case .categoryCellDetails(let cell):
                CellDetailsView(cell: cell,
                                authService: authService,
                                favoritesService: favoritesService)
        }
    }
}

#Preview {
    let contentService = ContentService()
    let vm = SearchViewModel(contentService: contentService)
    
    return NavigationStack {
        SearchView(vm: vm, authService: AuthService(), favoritesService: FavoritesService())
    }
}
