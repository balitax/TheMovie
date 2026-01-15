//
//  DetailMovieViewModelTests.swift
//  TheMovieTests
//

import XCTest
@testable import TheMovie
import SwiftData

final class DetailMovieViewModelTests: XCTestCase {
    
    @MainActor
    private var context: ModelContext!
    @MainActor
    private var sut: DetailMovieViewModel!
    
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
        let movie = makeMovieEntity(id: 21, title: "Iron Man")
        context.insert(movie)
        try? context.save()
        
        let mockRepo = MockMovieRepository()
        
        // WHEN
        sut = DetailMovieViewModel(repository: mockRepo, movie: movie)
        
        // THEN
        XCTAssertEqual(sut.state.movie?.id, 21)
        XCTAssertEqual(sut.state.movie?.title, "Iron Man")
    }
    
    // MARK: - Action Tests
    
    @MainActor
    func testLikeMovieAction() async {
        // GIVEN
        let movie = makeMovieEntity(id: 22, title: "Iron Man")
        context.insert(movie)
        try? context.save()
        
        let mockRepo = MockMovieRepository()
        sut = DetailMovieViewModel(repository: mockRepo, movie: movie)
        
        // WHEN
        sut.send(.likeMovie)
        
        // THEN
        XCTAssertEqual(mockRepo.invokedToggleFavorite?.id, 22)
        XCTAssertTrue(sut.state.movie?.isFavorite ?? false)
    }

    @MainActor
    func testLikeMovieActionFailure() async {
        // GIVEN
        let movie = makeMovieEntity(id: 23, title: "Iron Man")
        context.insert(movie)
        try? context.save()
        
        let error = NSError(domain: "test", code: 0, userInfo: [NSLocalizedDescriptionKey: "Toggle Error"])
        let mockRepo = MockMovieRepository()
        mockRepo.toggleFavoriteError = error
        sut = DetailMovieViewModel(repository: mockRepo, movie: movie)
        
        // WHEN
        sut.send(.likeMovie)
        
        // THEN
        XCTAssertEqual(sut.state.errorMessage, "Toggle Error")
    }
}
