//
//  MovieRepository.swift
//  TheMovie
//
//  Created by Aguscahyo on 14/01/26.
//

import Foundation

protocol MovieRepositoryProtocol: AnyObject {
    func getPopularMovies(page: Int) async throws -> PaginatedResult
    func searchMovie(query: String, page: Int) async throws -> PaginatedResult
    func getMovieDetail(id: Int) async throws -> MovieDetailDTO
}

struct PaginatedResult {
    let movies: [MovieEntity]
    let totalPages: Int
    let currentPage: Int
}

final class MovieRepository {

    private let remote: NetworkService
    private let local: MovieLocalDataSource

    init(remote: NetworkService = APIClient(), local: MovieLocalDataSource) {
        self.remote = remote
        self.local = local
    }


    func getPopularMovies(page: Int = 1) async throws -> PaginatedResult {

        // Offline-first (only for first page)
        if page == 1,
           let cached = try? local.fetchMovies(),
           !cached.isEmpty {
            // Return Int.max to allow trying to fetch next page (pagination sync will happen on page 2)
            return PaginatedResult(movies: cached, totalPages: Int.max, currentPage: 1)
        }

        // Fetch from API
        let response: MovieDTO = try await remote.request(.popular(page: page))

        let entities = response.results.map { $0.toEntity() }

        // Save locally (only first page)
        if page == 1 {
            try? local.clear()
            try? local.save(entities)
        }

        return PaginatedResult(
            movies: entities,
            totalPages: response.totalPages,
            currentPage: response.page
        )
    }
    
    func searchMovie(query: String, page: Int = 1) async throws -> PaginatedResult {
        let response: MovieDTO = try await remote.request(.search(query: query, page: page))

        let entities = response.results.map { $0.toEntity() }

        return PaginatedResult(
            movies: entities,
            totalPages: response.totalPages,
            currentPage: response.page
        )
    }

    func getMovieDetail(id: Int) async throws -> MovieDetailDTO {
        try await remote.request(.detail(id: id))
    }
}

extension MovieRepository: MovieRepositoryProtocol {}

