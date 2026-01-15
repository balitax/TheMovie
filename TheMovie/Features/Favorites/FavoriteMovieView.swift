//
//  FavoriteMovieView.swift
//  TheMovie
//
//  Created by Aguscahyo on 14/01/26.
//

import SwiftUI
import SwiftData

struct FavoriteMovieView: View {
    
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
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.state.movies) { movie in
                        NavigationLink {
                            let detailViewModel = DetailMovieViewModel(movie: movie)
                            DetailMovieView(viewModel: detailViewModel)
                        } label: {
                            ListMovieCellView(movie: movie) { faviroteMovie in
                                viewModel.toggleFavorite(faviroteMovie)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(16)
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
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: MovieEntity.self)
    let context = ModelContext(container)
    
    let appContainer = AppContainer(modelContext: context)
    FavoriteMovieView(viewModel: appContainer.makeFavoriteMovieViewModel())
}
