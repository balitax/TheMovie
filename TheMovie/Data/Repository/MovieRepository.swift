//
//  MovieRepository.swift
//  TheMovie
//
//  Created by Aguscahyo on 14/01/26.
//

import Foundation

protocol MovieRepositoryProtocol: AnyObject {
    func getPopularMovies(page: Int, forceRefresh: Bool) async throws -> PaginatedResult
    func searchMovie(query: String, page: Int) async throws -> PaginatedResult
    func getMovieDetail(id: Int) async throws -> MovieDetailDTO
    func getFavorites() throws -> [MovieEntity]
    func toggleFavorite(_ movie: MovieEntity) throws
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


    func getPopularMovies(page: Int = 1, forceRefresh: Bool = false) async throws -> PaginatedResult {

        // Offline-first (only for first page, if not refreshing)
        if !forceRefresh,
           page == 1,
           let cached = try? local.fetchMovies(),
           !cached.isEmpty {
            // Sync favorite status for cached data
            cached.forEach { $0.isFavorite = local.isFavorite(id: $0.id) }
            // Return Int.max to allow trying to fetch next page (pagination sync will happen on page 2)
            return PaginatedResult(movies: cached, totalPages: Int.max, currentPage: 1)
        }

        // Fetch from API
        let response: MovieDTO = try await remote.request(.popular(page: page))

        let entities = response.results.map { result in
            let entity = result.toEntity()
            entity.isFavorite = local.isFavorite(id: entity.id)
            return entity
        }

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

        let entities = response.results.map { result in
            let entity = result.toEntity()
            entity.isFavorite = local.isFavorite(id: entity.id)
            return entity
        }

        return PaginatedResult(
            movies: entities,
            totalPages: response.totalPages,
            currentPage: response.page
        )
    }

    func getMovieDetail(id: Int) async throws -> MovieDetailDTO {
        try await remote.request(.detail(id: id))
    }

    func getFavorites() throws -> [MovieEntity] {
        try local.fetchFavorites().map { $0.toMovieEntity() }
    }

    func toggleFavorite(_ movie: MovieEntity) throws {
        if local.isFavorite(id: movie.id) {
            try local.deleteFavorite(id: movie.id)
            movie.isFavorite = false
            
            // Also sync cached MovieEntity if exists
            if let cached = try? local.fetchMovie(id: movie.id) {
                cached.isFavorite = false
            }
        } else {
            let favorite = FavoriteMovieEntity(
                id: movie.id,
                title: movie.title,
                overview: movie.overview,
                posterPath: movie.posterPath,
                releaseDate: movie.releaseDate,
                popularity: movie.popularity,
                voteAverage: movie.voteAverage,
                voteCount: movie.voteCount
            )
            try local.saveFavorite(favorite)
            movie.isFavorite = true
            
            // Also sync cached MovieEntity if exists
            if let cached = try? local.fetchMovie(id: movie.id) {
                cached.isFavorite = true
            }
        }
    }
}

extension MovieRepository: MovieRepositoryProtocol {}

