//
//  MockMovieRepository.swift
//  TheMovie
//
//  Created by Aguscahyo on 14/01/26.
//

@testable import TheMovie

@MainActor
final class MockMovieRepository: MovieRepositoryProtocol {

    let result: Result<[MovieEntity], Error>

    init(result: Result<[MovieEntity], Error>) {
        self.result = result
    }

    func getPopularMovies(page: Int) async throws -> [MovieEntity] {
        switch result {
        case .success(let movies):
            return movies
        case .failure(let error):
            throw error
        }
    }
}
