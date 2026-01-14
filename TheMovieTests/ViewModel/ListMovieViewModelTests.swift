//
//  ListMovieViewModelTests.swift
//  TheMovie
//
//  Created by Aguscahyo on 14/01/26.
//

import XCTest
@testable import TheMovie
import SwiftData

@MainActor
final class ListMovieViewModelTests: XCTestCase {

    func testLoadPopularMoviesSuccess() async {

        // GIVEN
        let movies = [
            makeMovieEntity(id: 1, title: "Iron Man"),
            makeMovieEntity(id: 2, title: "Thor")
        ]

        let mockRepo = MockMovieRepository(
            popularResult: .success(movies),
            searchResult: .success([])
        )

        let viewModel = ListMovieViewModel(repository: mockRepo)

        // WHEN
        await viewModel.load()

        // THEN
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.movies.count, 2)
        XCTAssertEqual(viewModel.movies.first?.title, "Iron Man")
        XCTAssertNil(viewModel.errorMessage)
    }

    func testLoadPopularMoviesFailure() async {

        // GIVEN
        enum DummyError: Error { case failed }

        let mockRepo = MockMovieRepository(
            popularResult: .failure(DummyError.failed),
            searchResult: .success([])
        )

        let viewModel = ListMovieViewModel(repository: mockRepo)

        // WHEN
        await viewModel.load()

        // THEN
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.movies.isEmpty)
        XCTAssertNotNil(viewModel.errorMessage)
    }

    func testGetPopularMoviesFromRemote() async throws {
        
        // GIVEN: mock API response
        let dto = MovieDTO(
            page: 1,
            results: [
                MovieResult(
                    adult: false,
                    backdropPath: "/backdrop.jpg",
                    genreIDS: [28],
                    id: 1,
                    originalLanguage: "en",
                    originalTitle: "Iron Man",
                    overview: "Marvel movie",
                    popularity: 10.0,
                    posterPath: "/poster.jpg",
                    releaseDate: "2008-05-02",
                    title: "Iron Man",
                    video: false,
                    voteAverage: 8.5,
                    voteCount: 1000
                )
            ],
            totalPages: 1,
            totalResults: 1
        )
        
        let mockAPI = MockAPIClient(result: .success(dto))
        
        // GIVEN: in-memory SwiftData
        let container = try makeInMemoryContainer()
        let context = ModelContext(container)
        let local = MovieLocalDataSource(context: context)
        
        let repository = MovieRepository(
            remote: mockAPI,
            local: local
        )
        
        // WHEN
        let movies = try await repository.getPopularMovies(page: 1)
        
        // THEN
        XCTAssertEqual(movies.count, 1)
        XCTAssertEqual(movies.first?.id, 1)
        XCTAssertEqual(movies.first?.title, "Iron Man")
        XCTAssertEqual(movies.first?.posterPath, "/poster.jpg")
    }

    func testSearchMovieSuccess() async {
        
        let movies = [
            makeMovieEntity(id: 1, title: "Iron Man")
        ]
        
        let repo = MockMovieRepository(
            searchResult: .success(movies)
        )
        
        let viewModel = ListMovieViewModel(repository: repo)
        viewModel.searchText = "iron"
        
        await viewModel.search()
        
        XCTAssertEqual(viewModel.movies.count, 1)
        XCTAssertEqual(viewModel.movies.first?.title, "Iron Man")
    }
}
