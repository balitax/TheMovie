//
//  FavoriteMovieViewModelTests.swift
//  TheMovieTests
//

import XCTest
@testable import TheMovie
import SwiftData

final class FavoriteMovieViewModelTests: XCTestCase {
    
    @MainActor
    private var context: ModelContext!
    @MainActor
    private var sut: FavoriteMovieViewModel!
    
    @MainActor
    override func setUp() async throws {
        try await super.setUp()
        context = TestModelContainer.makeFreshContext()
    }
    
    @MainActor
    override func tearDown() async throws {
        // Clear all data from shared container to prevent pollution
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
        sut = FavoriteMovieViewModel(repository: mockRepo)
        
        // THEN
        XCTAssertTrue(sut.state.movies.isEmpty)
        XCTAssertNil(sut.state.errorMessage)
    }
    
    // MARK: - Fetch Tests
    
    @MainActor
    func testLoadFavoriteMoviesSuccess() async {
        // GIVEN
        let movie = makeMovieEntity(id: 1, title: "Favorite Movie")
        context.insert(movie)
        try? context.save()
        
        let mockRepo = MockMovieRepository(favoritesResult: .success([movie]))
        sut = FavoriteMovieViewModel(repository: mockRepo)
        
        // WHEN
        sut.loadFavoriteMovies()
        
        // THEN
        XCTAssertEqual(sut.state.movies.count, 1)
        XCTAssertEqual(sut.state.movies.first?.title, "Favorite Movie")
    }
    
    @MainActor
    func testLoadFavoriteMoviesFailure() async {
        // GIVEN
        let error = NSError(domain: "test", code: 0, userInfo: [NSLocalizedDescriptionKey: "Fetch Error"])
        let mockRepo = MockMovieRepository(favoritesResult: .failure(error))
        sut = FavoriteMovieViewModel(repository: mockRepo)
        
        // WHEN
        sut.loadFavoriteMovies()
        
        // THEN
        XCTAssertTrue(sut.state.movies.isEmpty)
        XCTAssertEqual(sut.state.errorMessage, "Fetch Error")
    }
    
    // MARK: - Action Tests
    
    @MainActor
    func testOnAppearAction() async {
        // GIVEN
        let movie = makeMovieEntity(id: 2, title: "Star Wars")
        context.insert(movie)
        try? context.save()
        
        let mockRepo = MockMovieRepository(favoritesResult: .success([movie]))
        sut = FavoriteMovieViewModel(repository: mockRepo)
        
        // WHEN
        sut.send(.onAppear)
        
        // THEN
        XCTAssertEqual(sut.state.movies.count, 1)
        XCTAssertEqual(sut.state.movies.first?.title, "Star Wars")
    }
    
    @MainActor
    func testDismissErrorAction() async {
        // GIVEN
        let mockRepo = MockMovieRepository()
        sut = FavoriteMovieViewModel(repository: mockRepo)
        
        // GIVEN state has error
        let error = NSError(domain: "test", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error"])
        mockRepo.favoritesResult = .failure(error)
        sut.loadFavoriteMovies()
        XCTAssertNotNil(sut.state.errorMessage)
        
        // WHEN
        sut.send(.dismissError)
        
        // THEN
        XCTAssertNil(sut.state.errorMessage)
    }
    
    @MainActor
    func testToggleFavoritePersistent() async {
        // GIVEN
        let movie = makeMovieEntity(id: 3, title: "Movie")
        context.insert(movie)
        try? context.save()
        
        let mockRepo = MockMovieRepository()
        sut = FavoriteMovieViewModel(repository: mockRepo)
        
        // WHEN
        sut.toggleFavorite(movie)
        
        // THEN
        XCTAssertEqual(mockRepo.invokedToggleFavorite?.id, movie.id)
    }
}
