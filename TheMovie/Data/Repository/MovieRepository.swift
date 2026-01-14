//
//  MovieRepository.swift
//  TheMovie
//
//  Created by Aguscahyo on 14/01/26.
//

import Foundation

@MainActor
protocol MovieRepositoryProtocol: AnyObject {
    func getPopularMovies(page: Int) async throws -> [MovieEntity]
    func searchMovie(query: String, page: Int) async throws -> [MovieEntity]
}

@MainActor
final class MovieRepository {

    private let remote: NetworkService
    private let local: MovieLocalDataSource

    init(remote: NetworkService, local: MovieLocalDataSource) {
        self.remote = remote
        self.local = local
    }

    func getPopularMovies(page: Int = 1) async throws -> [MovieEntity] {

        // Offline-first
        if let cached = try? local.fetchMovies(),
           !cached.isEmpty {
            return cached
        }

        // Fetch from API
        let response: MovieDTO = try await remote.request(.popular(page: page))

        let entities = response.results.map { $0.toEntity() }

        // Save locally
        try local.clear()
        try local.save(entities)

        return entities
    }
    
    func searchMovie(query: String, page: Int = 1) async throws -> [MovieEntity] {
        let response: MovieDTO = try await remote.request(.search(query: query, page: page))

        let entities = response.results.map { $0.toEntity() }

        return entities
    }
}

extension MovieRepository: MovieRepositoryProtocol {}

