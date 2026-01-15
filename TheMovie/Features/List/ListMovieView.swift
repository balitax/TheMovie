//
//  ListMovieView.swift
//  TheMovie
//
//  Created by Aguscahyo on 14/01/26.
//

import SwiftUI
import SwiftData

struct ListMovieView: View {

    private let columns: [GridItem] = Array(
        repeating: GridItem(.flexible(), spacing: 12),
        count: 2
    )

    @State private var searchMovie: String = ""
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
                                DetailMovieView()
                            } label: {
                                ListMovieCellView(movie: movie)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(16)
                }
                .background(Color.white)

                // MARK: - Loading Overlay
                if viewModel.state.isLoading {
                    LoadingView()
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
                text: $searchMovie,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Search movies"
            )
            .onSubmit(of: .search) {

            }
            .onAppear {
                viewModel.send(.onAppear)
            }
        }
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
