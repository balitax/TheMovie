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
