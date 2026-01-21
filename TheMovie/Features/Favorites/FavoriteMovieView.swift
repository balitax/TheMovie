//
//  FavoriteMovieView.swift
//  TheMovie
//
//  Created by Aguscahyo on 14/01/26.
//

import SwiftUI
import SwiftData

struct FavoriteMovieView: View {

    @Environment(\.modelContext) private var modelContext

    private let columns: [GridItem] = Array(
        repeating: GridItem(.flexible(), spacing: 12),
        count: 2
    )
    
    @State private var viewModel: FavoriteMovieViewModel
    
    init(viewModel: FavoriteMovieViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.state.movies.isEmpty {
                    EmptyStateView(
                        iconName: "heart.slash",
                        title: "No Favorites Yet",
                        message: "Mark movies as favorite to see them here."
                    )
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(viewModel.state.movies) { movie in
                                NavigationLink {
                                    let container = AppContainer(modelContext: modelContext)
                                    let detailViewModel = DetailMovieViewModel(repository: container.makeMovieRepository(), movie: movie)
                                    DetailMovieView(viewModel: detailViewModel)
                                } label: {
                                    ListMovieCellView(movie: movie, searchText: "") { favoriteMovie in
                                        viewModel.toggleFavorite(favoriteMovie)
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(16)
                    }
                }
            }
            .background(Color.white)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.white, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Favorite Movie")
                        .font(.headline)
                        .foregroundStyle(AppColor.textPrimary)
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
}

#Preview {
    let container = try! ModelContainer(for: MovieEntity.self)
    let context = ModelContext(container)
    
    let appContainer = AppContainer(modelContext: context)
    FavoriteMovieView(viewModel: appContainer.makeFavoriteMovieViewModel())
}
