//
//  FavoriteMovieViewModelTests.swift
//  TheMovieTests
//
//  Created by Aguscahyo on 15/01/26.
//

import XCTest
@testable import TheMovie
import SwiftData

final class FavoriteMovieViewModelTests: XCTestCase {
    
    // MARK: - Initialization Tests
    
    @MainActor
    func testInitialization() async throws {
        // GIVEN
        let container = try makeInMemoryContainer()
        let context = ModelContext(container)
        let dataSource = MovieLocalDataSource(context: context)
        
        // WHEN
        let viewModel = FavoriteMovieViewModel(localDataSource: dataSource)
        
        // THEN
        XCTAssertTrue(viewModel.state.movies.isEmpty)
    }
    
    // MARK: - Fetch Tests
    
    @MainActor
    func testLoadFavoriteMovies() async throws {
        // GIVEN
        let container = try makeInMemoryContainer()
        let context = ModelContext(container)
        let dataSource = MovieLocalDataSource(context: context)
        
        // Insert mixed data (favorites and non-favorites)
        let favMovie = makeMovieEntity(id: 1, title: "Favorite Movie")
        favMovie.isFavorite = true
        
        let nonFavMovie = makeMovieEntity(id: 2, title: "Regular Movie")
        nonFavMovie.isFavorite = false
        
        context.insert(favMovie)
        context.insert(nonFavMovie)
        try context.save()
        
        let viewModel = FavoriteMovieViewModel(localDataSource: dataSource)
        
        // WHEN
        viewModel.loadFavoriteMovies()
        
        // THEN
        XCTAssertEqual(viewModel.state.movies.count, 1)
        XCTAssertEqual(viewModel.state.movies.first?.title, "Favorite Movie")
        XCTAssertEqual(viewModel.state.movies.first?.id, 1)
    }
    
    @MainActor
    func testLoadFavoriteMoviesEmpty() async throws {
        // GIVEN
        let container = try makeInMemoryContainer()
        let context = ModelContext(container)
        let dataSource = MovieLocalDataSource(context: context)
        
        // Insert only non-favorite movie
        let nonFavMovie = makeMovieEntity(id: 2, title: "Regular Movie")
        nonFavMovie.isFavorite = false
        
        context.insert(nonFavMovie)
        try context.save()
        
        let viewModel = FavoriteMovieViewModel(localDataSource: dataSource)
        
        // WHEN
        viewModel.loadFavoriteMovies()
        
        // THEN
        XCTAssertTrue(viewModel.state.movies.isEmpty)
    }
    
    // MARK: - Action Tests
    
    @MainActor
    func testOnAppearAction() async throws {
        // GIVEN
        let container = try makeInMemoryContainer()
        let context = ModelContext(container)
        let dataSource = MovieLocalDataSource(context: context)
        
        // Pre-populate with a favorite
        let favMovie = makeMovieEntity(id: 1, title: "Start Wars")
        favMovie.isFavorite = true
        context.insert(favMovie)
        try context.save()
        
        let viewModel = FavoriteMovieViewModel(localDataSource: dataSource)
        
        // WHEN
        viewModel.send(.onAppear)
        
        // THEN
        XCTAssertEqual(viewModel.state.movies.count, 1)
        XCTAssertEqual(viewModel.state.movies.first?.title, "Start Wars")
    }
    
    @MainActor
    func testToggleFavoriteMovesMovieFromList() async throws {
        // GIVEN
        let container = try makeInMemoryContainer()
        let context = ModelContext(container)
        let dataSource = MovieLocalDataSource(context: context)
        
        let favMovie = makeMovieEntity(id: 1, title: "Favorite Movie")
        favMovie.isFavorite = true
        context.insert(favMovie)
        try context.save()
        
        let viewModel = FavoriteMovieViewModel(localDataSource: dataSource)
        viewModel.loadFavoriteMovies()
        
        // Verify initial state
        XCTAssertEqual(viewModel.state.movies.count, 1)
        
        // WHEN - Toggle favorite (un-favorite it)
        viewModel.toggleFavorite(favMovie)
        
        // THEN
        XCTAssertTrue(viewModel.state.movies.isEmpty)
        XCTAssertFalse(favMovie.isFavorite)
    }
}
