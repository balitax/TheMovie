//
//  ListMovieView.swift
//  TheMovie
//
//  Created by Aguscahyo on 14/01/26.
//

import SwiftUI
import SwiftData

struct ListMovieView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    private let columns: [GridItem] = Array(
        repeating: GridItem(.flexible(), spacing: 12),
        count: 2
    )
    
    @State private var viewModel: ListMovieViewModel
    
    init(viewModel: ListMovieViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.state.movies) { movie in
                            NavigationLink {
                                let container = AppContainer(modelContext: modelContext)
                                let detailViewModel = DetailMovieViewModel(repository: container.makeMovieRepository(), movie: movie)
                                DetailMovieView(viewModel: detailViewModel)
                            } label: {
                                ListMovieCellView(movie: movie) { favoriteMovie in
                                    viewModel.toggleFavorite(favoriteMovie)
                                }
                            }
                            .buttonStyle(.plain)
                            .accessibilityIdentifier("movie_cell_\(movie.id)")
                            .onAppear {
                                if movie == viewModel.state.movies.last {
                                    viewModel.send(.loadMore)
                                }
                            }
                        }
                    }
                    .padding(16)
                    
                    if viewModel.state.isFetchingMore {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                }
                .accessibilityIdentifier("movie_list")
                .background(Color.white)
                
                // MARK: - Loading Overlay
                if viewModel.state.isLoading {
                    LoadingView()
                } else if viewModel.state.movies.isEmpty {
                    emptyStateView
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.white, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("The Movie")
                        .font(.headline)
                        .foregroundStyle(AppColor.textPrimary)
                }
            }
            .searchable(
                text: viewModel.searchTextBinding,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Search movies"
            )
            .onSubmit(of: .search) {
                viewModel.send(.searchMovie)
            }
            .onChange(of: viewModel.state.searchText) { _, newValue in
                if newValue.isEmpty {
                    viewModel.send(.reset)
                }
            }
            .onAppear {
                viewModel.send(.onAppear)
            }
            .alert(
                "Error",
                isPresented: Binding(
                    get: { viewModel.state.errorMessage != nil },
                    set: { _ in viewModel.send(.dismissError) }
                )
            ) {
                Button("OK") {}
            } message: {
                Text(viewModel.state.errorMessage ?? "")
            }
        }
    }
    
    var emptyStateView: some View {
        EmptyStateView(
            iconName: viewModel.state.searchText.isEmpty ? "film.stack" : "magnifyingglass",
            title: viewModel.state.searchText.isEmpty ? "No Movies" : "No Results Found",
            message: viewModel.state.searchText.isEmpty ? "Popular movies will appear here." : "We couldn't find any movies matching '\(viewModel.state.searchText)'."
        )
    }
}

#Preview {
    let container = try! ModelContainer(for: MovieEntity.self)
    let context = ModelContext(container)
    
    let appContainer = AppContainer(modelContext: context)
    
    ListMovieView(
        viewModel: appContainer.makeListMovieViewModel()
    )
}
