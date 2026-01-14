//
//  ListMovieViewModel.swift
//  TheMovie
//
//  Created by Aguscahyo on 14/01/26.
//

import Foundation
import SwiftUI

@MainActor
@Observable
final class ListMovieViewModel {

    var movies: [MovieEntity] = []
    var isLoading = false
    var errorMessage: String?
    var searchText: String = ""

    private let repository: MovieRepositoryProtocol

    init(repository: MovieRepositoryProtocol) {
        self.repository = repository
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            movies = try await repository.getPopularMovies(page: 1)
        } catch {
            movies = []
            errorMessage = error.localizedDescription
        }
    }

    func search() async {
        guard !searchText.isEmpty else { return }

        movies = (try? await repository.searchMovie(
            query: searchText,
            page: 1
        )) ?? []
    }
}
