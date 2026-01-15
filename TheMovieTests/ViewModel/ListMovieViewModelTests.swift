//
//  ListMovieViewModelTests.swift
//  TheMovie
//
//  Created by Aguscahyo on 14/01/26.
//

import XCTest
@testable import TheMovie
import SwiftData
internal import SwiftUI

final class ListMovieViewModelTests: XCTestCase {
    
    // MARK: - Initialization Tests
    
    @MainActor
    func testInitialization() async {
        // GIVEN
        let mockRepo = MockMovieRepository()
        
        // WHEN
        let viewModel = ListMovieViewModel(repository: mockRepo)
        
        // THEN
        XCTAssertTrue(viewModel.state.movies.isEmpty)
        XCTAssertFalse(viewModel.state.isLoading)
        XCTAssertFalse(viewModel.state.hasLoaded)
        XCTAssertEqual(viewModel.state.searchText, "")
    }
    
    // MARK: - Fetch Movie Tests

    @MainActor
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
        await viewModel.fetchMovie()

        // THEN
        XCTAssertFalse(viewModel.state.isLoading)
        XCTAssertEqual(viewModel.state.movies.count, 2)
        XCTAssertEqual(viewModel.state.movies.first?.title, "Iron Man")
    }

    @MainActor
    func testLoadPopularMoviesFailure() async {
        // GIVEN
        enum DummyError: Error { case failed }

        let mockRepo = MockMovieRepository(
            popularResult: .failure(DummyError.failed),
            searchResult: .success([])
        )

        let viewModel = ListMovieViewModel(repository: mockRepo)

        // WHEN
        await viewModel.fetchMovie()

        // THEN
        XCTAssertFalse(viewModel.state.isLoading)
        XCTAssertTrue(viewModel.state.movies.isEmpty)
    }
    
    @MainActor
    func testLoadingStatesDuringFetch() async {
        // GIVEN
        let movies = [makeMovieEntity(id: 1, title: "Iron Man")]
        let mockRepo = MockMovieRepository(popularResult: .success(movies))
        let viewModel = ListMovieViewModel(repository: mockRepo)
        
        // WHEN
        let fetchTask = Task {
            await viewModel.fetchMovie()
        }
        
        // Wait for task to complete
        await fetchTask.value
        
        // THEN
        XCTAssertFalse(viewModel.state.isLoading)
    }

    @MainActor
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
    
    // MARK: - Search Tests

    @MainActor
    func testSearchMovieSuccess() async {
        // GIVEN
        let movies = [
            makeMovieEntity(id: 1, title: "Iron Man")
        ]
        
        let repo = MockMovieRepository(
            searchResult: .success(movies)
        )
        
        let viewModel = ListMovieViewModel(repository: repo)
        viewModel.searchTextBinding.wrappedValue = "iron"
        
        // WHEN
        await viewModel.search()

        // THEN
        XCTAssertEqual(viewModel.state.movies.count, 1)
        XCTAssertEqual(viewModel.state.movies.first?.title, "Iron Man")
        XCTAssertFalse(viewModel.state.isLoading)
    }
    
    @MainActor
    func testSearchMovieFailure() async {
        // GIVEN
        enum DummyError: Error { case failed }
        let repo = MockMovieRepository(searchResult: .failure(DummyError.failed))
        let viewModel = ListMovieViewModel(repository: repo)
        viewModel.searchTextBinding.wrappedValue = "nonexistent"
        
        // WHEN
        await viewModel.search()
        
        // THEN
        XCTAssertTrue(viewModel.state.movies.isEmpty)
        XCTAssertFalse(viewModel.state.isLoading)
    }
    
    @MainActor
    func testSearchWithEmptyQuery() async {
        // GIVEN
        let movies = [makeMovieEntity(id: 1, title: "Iron Man")]
        let repo = MockMovieRepository(searchResult: .success(movies))
        let viewModel = ListMovieViewModel(repository: repo)
        viewModel.searchTextBinding.wrappedValue = ""
        
        // WHEN
        await viewModel.search()
        
        // THEN
        XCTAssertTrue(viewModel.state.movies.isEmpty)
        XCTAssertFalse(viewModel.state.isLoading)
    }
    
    @MainActor
    func testLoadingStatesDuringSearch() async {
        // GIVEN
        let movies = [makeMovieEntity(id: 1, title: "Iron Man")]
        let repo = MockMovieRepository(searchResult: .success(movies))
        let viewModel = ListMovieViewModel(repository: repo)
        viewModel.searchTextBinding.wrappedValue = "iron"
        
        // WHEN
        let searchTask = Task {
            await viewModel.search()
        }
        
        // Wait for task to complete
        await searchTask.value
        
        // THEN
        XCTAssertFalse(viewModel.state.isLoading)
    }
    
    // MARK: - Action Tests
    
    @MainActor
    func testOnAppearActionFirstTime() async {
        // GIVEN
        let movies = [makeMovieEntity(id: 1, title: "Iron Man")]
        let mockRepo = MockMovieRepository(popularResult: .success(movies))
        let viewModel = ListMovieViewModel(repository: mockRepo)
        
        XCTAssertFalse(viewModel.state.hasLoaded)
        
        // WHEN
        viewModel.send(.onAppear)
        
        // Wait a bit for async task
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // THEN
        XCTAssertTrue(viewModel.state.hasLoaded)
        XCTAssertEqual(viewModel.state.movies.count, 1)
    }
    
    @MainActor
    func testOnAppearActionSecondTime() async {
        // GIVEN
        let movies = [makeMovieEntity(id: 1, title: "Iron Man")]
        let mockRepo = MockMovieRepository(popularResult: .success(movies))
        let viewModel = ListMovieViewModel(repository: mockRepo)
        
        // First appearance
        viewModel.send(.onAppear)
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        let firstMovieCount = viewModel.state.movies.count
        
        // WHEN - Second appearance (should not reload)
        viewModel.send(.onAppear)
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // THEN
        XCTAssertEqual(viewModel.state.movies.count, firstMovieCount)
        XCTAssertTrue(viewModel.state.hasLoaded)
    }
    
    @MainActor
    func testSearchMovieAction() async {
        // GIVEN
        let movies = [makeMovieEntity(id: 1, title: "Iron Man")]
        let repo = MockMovieRepository(searchResult: .success(movies))
        let viewModel = ListMovieViewModel(repository: repo)
        viewModel.searchTextBinding.wrappedValue = "iron"
        
        // WHEN
        viewModel.send(.searchMovie)
        
        // Wait a bit for async task
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // THEN
        XCTAssertEqual(viewModel.state.movies.count, 1)
        XCTAssertEqual(viewModel.state.movies.first?.title, "Iron Man")
    }
    
    // MARK: - Favorite Toggle Tests
    
    @MainActor
    func testToggleFavorite() async {
        // GIVEN
        let movie = makeMovieEntity(id: 1, title: "Iron Man")
        let mockRepo = MockMovieRepository()
        let viewModel = ListMovieViewModel(repository: mockRepo)
        
        let initialFavoriteState = movie.isFavorite
        
        // WHEN
        viewModel.toggleFavorite(movie)
        
        // THEN
        let afterFirstToggle = movie.isFavorite
        XCTAssertNotEqual(afterFirstToggle, initialFavoriteState)
        
        // WHEN - toggle again
        viewModel.toggleFavorite(movie)
        
        // THEN
        let afterSecondToggle = movie.isFavorite
        XCTAssertEqual(afterSecondToggle, initialFavoriteState)
    }
    
    // MARK: - Binding Tests
    
    @MainActor
    func testSearchTextBinding() async {
        // GIVEN
        let mockRepo = MockMovieRepository()
        let viewModel = ListMovieViewModel(repository: mockRepo)
        
        // WHEN
        let binding = viewModel.searchTextBinding
        
        // THEN
        XCTAssertEqual(binding.wrappedValue, "")
        
        // WHEN - set new value
        binding.wrappedValue = "iron man"
        
        // THEN
        XCTAssertEqual(viewModel.state.searchText, "iron man")
        XCTAssertEqual(binding.wrappedValue, "iron man")
    }
}
