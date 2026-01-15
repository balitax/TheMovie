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
    var errorMessage: String?
}

// MARK: - ACTION
enum FavoriteMovieAction {
    case onAppear
    case dismissError
}

@Observable
final class FavoriteMovieViewModel {

    // MARK: Variables
    private(set) var state = FavoriteMovieState()
    private let repository: MovieRepositoryProtocol

    init(repository: MovieRepositoryProtocol) {
        self.repository = repository
    }

    func send(_ action: FavoriteMovieAction) {
        switch action {
        case .onAppear:
            loadFavoriteMovies()
        case .dismissError:
            state.errorMessage = nil
        }
    }
}

extension FavoriteMovieViewModel {
    func loadFavoriteMovies() {
        do {
            state.movies = try repository.getFavorites()
        } catch {
            state.movies = []
            state.errorMessage = error.localizedDescription
            print("error log console :\(error.localizedDescription)")
        }
    }

    func toggleFavorite(_ movie: MovieEntity) {
        do {
            try repository.toggleFavorite(movie)
            loadFavoriteMovies()
        } catch {
            state.errorMessage = error.localizedDescription
        }
    }
}
