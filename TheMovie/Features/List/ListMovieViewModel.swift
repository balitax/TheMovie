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
    
    var currentPage: Int = 1
    var totalPages: Int = 1
    var isFetchingMore: Bool = false
    var errorMessage: String?
    
    var canLoadMore: Bool {
        !isLoading && !isFetchingMore && currentPage < totalPages
    }
}

// MARK: - ACTION
enum ListMovieAction {
    case onAppear
    case refresh
    case searchMovie
    case reset
    case loadMore
    case dismissError
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
            if !state.hasLoaded {
                state.hasLoaded = true
                state.isLoading = true
                Task {
                    await fetchMovie(page: 1)
                }
            } else {
                // Re-sync favorites for existing list when coming back to screen
                syncFavorites()
            }
        case .refresh:
            state.hasLoaded = true // Prevent auto-load conflict if any
            Task {
                await fetchMovie(page: 1, forceRefresh: true)
            }
        case .searchMovie:
            state.isLoading = true
            Task {
                await search(page: 1)
            }
        case .reset:
            state.hasLoaded = true
            state.isLoading = true
            Task {
                await fetchMovie(page: 1)
            }
        case .loadMore:
            guard state.canLoadMore else { return }
            Task {
                if state.searchText.isEmpty {
                    await fetchMovie(page: state.currentPage + 1)
                } else {
                    await search(page: state.currentPage + 1)
                }
            }
        case .dismissError:
            state.errorMessage = nil
        }
    }
}

extension ListMovieViewModel {
    func fetchMovie(page: Int = 1, forceRefresh: Bool = false) async {
        if page == 1 {
            state.isLoading = true
        } else {
            state.isFetchingMore = true
        }
        
        defer {
            state.isLoading = false
            state.isFetchingMore = false
        }

        do {
            let result = try await repository.getPopularMovies(page: page, forceRefresh: forceRefresh)
            if page == 1 {
                state.movies = result.movies
            } else {
                state.movies.append(contentsOf: result.movies)
            }
            state.currentPage = result.currentPage
            state.totalPages = result.totalPages
        } catch {
            if page == 1 { state.movies = [] }
            state.errorMessage = error.localizedDescription
        }
    }

    func search(page: Int = 1) async {
        guard !state.searchText.isEmpty else {
            await fetchMovie(page: 1)
            return
        }

        if page == 1 {
            state.isLoading = true
        } else {
            state.isFetchingMore = true
        }
        
        defer {
            state.isLoading = false
            state.isFetchingMore = false
        }

        do {
            let result = try await repository.searchMovie(
                query: state.searchText,
                page: page
            )
            
            if page == 1 {
                state.movies = result.movies
            } else {
                state.movies.append(contentsOf: result.movies)
            }
            state.currentPage = result.currentPage
            state.totalPages = result.totalPages
        } catch {
            if page == 1 { state.movies = [] }
            state.errorMessage = error.localizedDescription
        }
    }

    func toggleFavorite(_ movie: MovieEntity) {
        do {
            try repository.toggleFavorite(movie)
        } catch {
            state.errorMessage = error.localizedDescription
        }
    }

    private func syncFavorites() {
        guard let favorites = try? repository.getFavorites() else { return }
        let favoriteIds = Set(favorites.map { $0.id })
        
        for index in state.movies.indices {
            state.movies[index].isFavorite = favoriteIds.contains(state.movies[index].id)
        }
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
