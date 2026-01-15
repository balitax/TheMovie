//
//  MockMovieRepository.swift
//  TheMovie
//
//  Created by Aguscahyo on 14/01/26.
//

@testable import TheMovie

final class MockMovieRepository: MovieRepositoryProtocol {

    let popularResult: Result<[MovieEntity], Error>
    let searchResult: Result<[MovieEntity], Error>
    let detailResult: Result<MovieDetailDTO, Error>

    init(
        popularResult: Result<[MovieEntity], Error> = .success([]),
        searchResult: Result<[MovieEntity], Error> = .success([]),
        detailResult: Result<MovieDetailDTO, Error> = .success(makeMovieDetailDTO())
    ) {
        self.popularResult = popularResult
        self.searchResult = searchResult
        self.detailResult = detailResult
    }

    func getPopularMovies(page: Int) async throws -> PaginatedResult {
        switch popularResult {
        case .success(let movies): 
            return PaginatedResult(movies: movies, totalPages: 1, currentPage: 1)
        case .failure(let error): throw error
        }
    }

    func searchMovie(query: String, page: Int) async throws -> PaginatedResult {
        switch searchResult {
        case .success(let movies): 
            return PaginatedResult(movies: movies, totalPages: 1, currentPage: 1)
        case .failure(let error): throw error
        }
    }
    
    func getMovieDetail(id: Int) async throws -> MovieDetailDTO {
        switch detailResult {
        case .success(let detail): return detail
        case .failure(let error): throw error
        }
    }
}
