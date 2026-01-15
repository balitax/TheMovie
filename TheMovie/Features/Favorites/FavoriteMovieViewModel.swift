//
//  FavoriteMovieViewModel.swift
//  TheMovie
//
//  Created by Aguscahyo on 15/01/26.
//

import Foundation
import SwiftUI
import Combine

// MARK: - STATE
struct FavoriteMovieState {
    var movies: [MovieEntity] = []
}

// MARK: - ACTION
enum FavoriteMovieAction {
    case onAppear
}

@Observable
final class FavoriteMovieViewModel {

    // MARK: Variables
    private(set) var state = FavoriteMovieState()
    private let localDataSource: MovieLocalDataSource

    init(localDataSource: MovieLocalDataSource) {
        self.localDataSource = localDataSource
    }

    func send(_ action: FavoriteMovieAction) {
        switch action {
        case .onAppear:
            loadFavoriteMovies()
        }
    }
}

extension FavoriteMovieViewModel {
    func loadFavoriteMovies() {
        do {
            let movies = try localDataSource.fetchMovies()
            state.movies = movies.filter { $0.isFavorite }
        } catch {
            state.movies = []
            print("error log console :\(error.localizedDescription)")
        }
    }

    func toggleFavorite(_ movie: MovieEntity) {
        movie.isFavorite.toggle()
        loadFavoriteMovies()
    }
}
