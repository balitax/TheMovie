//
//  ListMovieViewModelTests.swift
//  TheMovieTests
//

import XCTest
@testable import TheMovie
import SwiftData
import SwiftUI

final class ListMovieViewModelTests: XCTestCase {
    
    @MainActor
    private var context: ModelContext!
    @MainActor
    private var sut: ListMovieViewModel!
    
    @MainActor
    override func setUp() async throws {
        try await super.setUp()
        context = TestModelContainer.makeFreshContext()
    }
    
    @MainActor
    override func tearDown() async throws {
        try? context.delete(model: MovieEntity.self)
        try? context.delete(model: FavoriteMovieEntity.self)
        try? context.save()
        
        context = nil
        sut = nil
        try await super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    @MainActor
    func testInitialization() async {
        // GIVEN
        let mockRepo = MockMovieRepository()
        
        // WHEN
        sut = ListMovieViewModel(repository: mockRepo)
        
        // THEN
        XCTAssertTrue(sut.state.movies.isEmpty)
        XCTAssertFalse(sut.state.isLoading)
        XCTAssertFalse(sut.state.hasLoaded)
    }
    
    // MARK: - Fetch Movie Tests

    @MainActor
    func testLoadPopularMoviesSuccess() async {
        // GIVEN
        let movie1 = makeMovieEntity(id: 11, title: "Iron Man")
        let movie2 = makeMovieEntity(id: 12, title: "Thor")
        context.insert(movie1)
        context.insert(movie2)
        try? context.save()
        
        let mockRepo = MockMovieRepository(popularResult: .success([movie1, movie2]))
        sut = ListMovieViewModel(repository: mockRepo)

        // WHEN
        await sut.fetchMovie()

        // THEN
        XCTAssertFalse(sut.state.isLoading)
        XCTAssertEqual(sut.state.movies.count, 2)
    }

    // MARK: - Search Tests

    @MainActor
    func testSearchMovieSuccess() async {
        // GIVEN
        let movie = makeMovieEntity(id: 13, title: "Iron Man")
        context.insert(movie)
        try? context.save()
        
        let repo = MockMovieRepository(searchResult: .success([movie]))
        sut = ListMovieViewModel(repository: repo)
        sut.searchTextBinding.wrappedValue = "iron"
        
        // WHEN
        await sut.search()

        // THEN
        XCTAssertEqual(sut.state.movies.count, 1)
        XCTAssertFalse(sut.state.isLoading)
    }
    
    // MARK: - Favorite Toggle Tests
    
    @MainActor
    func testToggleFavoritePersistent() async {
        // GIVEN
        let movie = makeMovieEntity(id: 14, title: "Iron Man")
        context.insert(movie)
        try? context.save()
        
        let mockRepo = MockMovieRepository()
        sut = ListMovieViewModel(repository: mockRepo)
        
        // WHEN
        sut.toggleFavorite(movie)
        
        // THEN
        XCTAssertEqual(mockRepo.invokedToggleFavorite?.id, 14)
        XCTAssertTrue(movie.isFavorite)
    }
}
