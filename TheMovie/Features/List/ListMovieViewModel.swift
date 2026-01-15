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
    var searchText: String = ""
}

// MARK: - ACTION
enum ListMovieAction {
    case onAppear
    case searchMovie(query: String)
    case errorMessage(message: String)
}

// MARK: - EVENT
enum ListMovieEvent {
    case showLoading(loading: Bool)
    case showErrorMessage(message: String)
}

@MainActor
@Observable
final class ListMovieViewModel {

    // MARK: Variables
    private(set) var state = ListMovieState()
    @ObservationIgnored let event = PassthroughSubject<ListMovieEvent, Never>()

    // MARK: - Dependencies
    private let repository: MovieRepositoryProtocol

    init(repository: MovieRepositoryProtocol) {
        self.repository = repository
    }

    func send(_ action: ListMovieAction) {
        switch action {
        case .onAppear:
            Task {
                await fetchMovie()
            }
        case .searchMovie(let query):
            state.searchText = query
            Task {
                await search()
            }
        case .errorMessage(let message):
            event.send(.showErrorMessage(message: message))
        }
    }

    func fetchMovie() async {
        state.isLoading = true
        defer {
            state.isLoading = false
        }

        do {
            state.movies = try await repository.getPopularMovies(page: 1)
            print("MOVIES ", state.movies)
        } catch {
            state.movies = []
            send(.errorMessage(message: error.localizedDescription))
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
            send(.errorMessage(message: error.localizedDescription))
        }
    }
}
