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

    init(
        popularResult: Result<[MovieEntity], Error> = .success([]),
        searchResult: Result<[MovieEntity], Error> = .success([])
    ) {
        self.popularResult = popularResult
        self.searchResult = searchResult
    }

    func getPopularMovies(page: Int) async throws -> [MovieEntity] {
        switch popularResult {
        case .success(let movies): return movies
        case .failure(let error): throw error
        }
    }

    func searchMovie(query: String, page: Int) async throws -> [MovieEntity] {
        switch searchResult {
        case .success(let movies): return movies
        case .failure(let error): throw error
        }
    }
}
