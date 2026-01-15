//
//  MockMovieRepository.swift
//  TheMovie
//
//  Created by Aguscahyo on 14/01/26.
//

@testable import TheMovie

final class MockMovieRepository: MovieRepositoryProtocol {

    var popularResult: Result<[MovieEntity], Error>?
    var searchResult: Result<[MovieEntity], Error>?
    var detailResult: Result<MovieDetailDTO, Error>?
    var favoritesResult: Result<[MovieEntity], Error>?
    var toggleFavoriteError: Error?
    
    var invokedToggleFavorite: MovieEntity?

    init(
        popularResult: Result<[MovieEntity], Error>? = nil,
        searchResult: Result<[MovieEntity], Error>? = nil,
        detailResult: Result<MovieDetailDTO, Error>? = nil,
        favoritesResult: Result<[MovieEntity], Error>? = nil
    ) {
        self.popularResult = popularResult
        self.searchResult = searchResult
        self.detailResult = detailResult
        self.favoritesResult = favoritesResult
    }

    func getPopularMovies(page: Int, forceRefresh: Bool) async throws -> PaginatedResult {
        switch popularResult ?? .success([]) {
        case .success(let movies): 
            return PaginatedResult(movies: movies, totalPages: 1, currentPage: 1)
        case .failure(let error): throw error
        }
    }

    func searchMovie(query: String, page: Int) async throws -> PaginatedResult {
        switch searchResult ?? .success([]) {
        case .success(let movies): 
            return PaginatedResult(movies: movies, totalPages: 1, currentPage: 1)
        case .failure(let error): throw error
        }
    }
    
    func getMovieDetail(id: Int) async throws -> MovieDetailDTO {
        switch detailResult ?? .success(makeMovieDetailDTO()) {
        case .success(let detail): return detail
        case .failure(let error): throw error
        }
    }

    func getFavorites() throws -> [MovieEntity] {
        switch favoritesResult ?? .success([]) {
        case .success(let movies): return movies
        case .failure(let error): throw error
        }
    }

    func toggleFavorite(_ movie: MovieEntity) throws {
        invokedToggleFavorite = movie
        if let error = toggleFavoriteError {
            throw error
        }
        movie.isFavorite.toggle()
    }
}
