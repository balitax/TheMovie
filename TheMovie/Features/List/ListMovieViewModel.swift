//
//  ListMovieViewModel.swift
//  TheMovie
//
//  Created by Aguscahyo on 14/01/26.
//

import Foundation
import SwiftUI
import Combine

// MARK: - STATE
struct ListMovieState {
    var movies: [MovieEntity] = []
    var isLoading = false
    var hasLoaded: Bool = false
    var searchText: String = ""
}

// MARK: - ACTION
enum ListMovieAction {
    case onAppear
    case searchMovie
}

@Observable
final class ListMovieViewModel {

    // MARK: Variables
    private(set) var state = ListMovieState()

    // MARK: - Dependencies
    private let repository: MovieRepositoryProtocol

    init(repository: MovieRepositoryProtocol) {
        self.repository = repository
    }

    func send(_ action: ListMovieAction) {
        switch action {
        case .onAppear:
            guard !state.hasLoaded else { return }
            state.hasLoaded = true
            Task {
                await fetchMovie()
            }
        case .searchMovie:
            Task {
                await search()
            }
        }
    }
}

extension ListMovieViewModel {
    func fetchMovie() async {
        state.isLoading = true
        defer {
            state.isLoading = false
        }

        do {
            state.movies = try await repository.getPopularMovies(page: 1)
        } catch {
            state.movies = []
            print("error log console : \(error.localizedDescription)")
        }
    }

    func search() async {
        guard !state.searchText.isEmpty else {
            state.movies = []
            return
        }

        state.isLoading = true
        defer {
            state.isLoading = false
        }

        do {
            state.movies = try await repository.searchMovie(
                query: state.searchText,
                page: 1
            )
        } catch {
            state.movies = []
            print("error log console : \(error.localizedDescription)")
        }
    }

    func toggleFavorite(_ movie: MovieEntity) {
        movie.isFavorite.toggle()
    }

    var searchTextBinding: Binding<String> {
        Binding(
            get: { self.state.searchText },
            set: { newValue in
                self.state.searchText = newValue
            }
        )
    }
}
