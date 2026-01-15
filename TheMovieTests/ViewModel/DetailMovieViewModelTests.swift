//
//  DetailMovieViewModelTests.swift
//  TheMovie
//
//  Created by Aguscahyo on 15/01/26.
//

import XCTest
@testable import TheMovie
internal import SwiftUI

final class DetailMovieViewModelTests: XCTestCase {
    
    // MARK: - Initialization Tests
    
    @MainActor
    func testInitialization() async {
        // GIVEN
        let movie = makeMovieEntity(id: 1, title: "Iron Man")
        let mockRepo = MockMovieRepository()
        
        // WHEN
        let viewModel = DetailMovieViewModel(repository: mockRepo, movie: movie)
        
        // THEN
        let state = viewModel.state
        let stateMovie = state.movie
        let stateDetail = state.detail
        let showTrailer = state.showTrailer
        let headerHeight = state.headerHeight

        let movieId = stateMovie?.id
        let movieTitle = stateMovie?.title
        
        XCTAssertNotNil(stateMovie)
        XCTAssertEqual(movieId, 1)
        XCTAssertEqual(movieTitle, "Iron Man")
        XCTAssertNil(stateDetail)
        XCTAssertFalse(showTrailer)
        XCTAssertEqual(headerHeight, 420)
    }
    
    @MainActor
    func testInitializationWithNilMovie() async {
        // GIVEN
        let mockRepo = MockMovieRepository()
        
        // WHEN
        let viewModel = DetailMovieViewModel(repository: mockRepo, movie: nil)
        
        // THEN
        let state = viewModel.state
        let stateMovie = state.movie
        let stateDetail = state.detail

        XCTAssertNil(stateMovie)
        XCTAssertNil(stateDetail)
    }
    
    // MARK: - Fetch Movie Detail Tests
    
    @MainActor
    func testFetchMovieDetailSuccess() async {
        // GIVEN
        let movie = makeMovieEntity(id: 1, title: "Iron Man")
        let mockDetail = makeMovieDetailDTO(
            genres: [
                GenreDTO(id: 28, name: "Action"),
                GenreDTO(id: 12, name: "Adventure"),
                GenreDTO(id: 878, name: "Science Fiction")
            ],
            productionCompanies: [
                ProductionCompanyDTO(id: 1, name: "Marvel Studios"),
                ProductionCompanyDTO(id: 2, name: "Paramount Pictures")
            ],
            productionCountries: [
                ProductionCountryDTO(name: "United States of America"),
                ProductionCountryDTO(name: "Canada")
            ],
            spokenLanguages: [
                SpokenLanguageDTO(name: "English"),
                SpokenLanguageDTO(name: "Spanish")
            ],
            videos: MovieVideoResponseDTO(
                results: [
                    MovieVideoDTO(
                        id: "1",
                        key: "8hYlB38asDY",
                        name: "Official Trailer",
                        site: "YouTube"
                    )
                ]
            )
        )
        let mockRepo = MockMovieRepository(
            detailResult: .success(mockDetail)
        )
        let viewModel = DetailMovieViewModel(repository: mockRepo, movie: movie)
        
        // WHEN
        await viewModel.fetchMovieDetail()
        
        // THEN
        let detail = viewModel.state.detail
        let genres = viewModel.movieGenres
        let companies = viewModel.movieProductionCompanies
        let countries = viewModel.movieProductionCountries
        let languages = viewModel.movieLanguages
        let youtubeURL = viewModel.youtubeURL

        XCTAssertNotNil(detail)
        XCTAssertEqual(genres, "Action, Adventure, Science Fiction")
        XCTAssertEqual(companies, "Marvel Studios, Paramount Pictures")
        XCTAssertEqual(countries, "United States of America, Canada")
        XCTAssertEqual(languages, "English, Spanish")
        XCTAssertEqual(youtubeURL, "https://www.youtube.com/watch?v=8hYlB38asDY")
    }
    
    @MainActor
    func testFetchMovieDetailFailure() async {
        // GIVEN
        enum DummyError: Error { case failed }
        let movie = makeMovieEntity(id: 1, title: "Iron Man")
        let mockRepo = MockMovieRepository(
            detailResult: .failure(DummyError.failed)
        )
        let viewModel = DetailMovieViewModel(repository: mockRepo, movie: movie)
        
        // WHEN
        await viewModel.fetchMovieDetail()
        
        // THEN
        let detail = viewModel.state.detail
        XCTAssertNil(detail)
    }
    
    @MainActor
    func testFetchMovieDetailWithNilMovie() async {
        // GIVEN
        let mockRepo = MockMovieRepository()
        let viewModel = DetailMovieViewModel(repository: mockRepo, movie: nil)
        
        // WHEN
        await viewModel.fetchMovieDetail()
        
        // THEN
        let detail = viewModel.state.detail
        XCTAssertNil(detail)
    }
    
    // MARK: - Action Tests
    
    @MainActor
    func testOnAppearAction() async {
        // GIVEN
        let movie = makeMovieEntity(id: 1, title: "Iron Man")
        let mockDetail = makeMovieDetailDTO()
        let mockRepo = MockMovieRepository(
            detailResult: .success(mockDetail)
        )
        let viewModel = DetailMovieViewModel(repository: mockRepo, movie: movie)
        
        // WHEN
        viewModel.send(.onAppear)
        
        // Wait a bit for async task to complete
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // THEN
        let detail = viewModel.state.detail
        XCTAssertNotNil(detail)
    }
    
    @MainActor
    func testShowTrailerAction() async {
        // GIVEN
        let movie = makeMovieEntity(id: 1, title: "Iron Man")
        let mockRepo = MockMovieRepository()
        let viewModel = DetailMovieViewModel(repository: mockRepo, movie: movie)
        
        // Initial state
        let initialState = viewModel.state.showTrailer
        XCTAssertFalse(initialState)
        
        // WHEN
        viewModel.send(.showTrailer)
        
        // THEN
        let afterFirstToggle = viewModel.state.showTrailer
        XCTAssertTrue(afterFirstToggle)
        
        // WHEN - toggle again
        viewModel.send(.showTrailer)
        
        // THEN
        let afterSecondToggle = viewModel.state.showTrailer
        XCTAssertFalse(afterSecondToggle)
    }
    
    @MainActor
    func testLikeMovieAction() async {
        // GIVEN
        let movie = makeMovieEntity(id: 1, title: "Iron Man")
        let mockRepo = MockMovieRepository()
        let viewModel = DetailMovieViewModel(repository: mockRepo, movie: movie)
        
        // Initial state
        let initialFavorite = viewModel.state.movie?.isFavorite
        XCTAssertFalse(initialFavorite ?? true)
        
        // WHEN
        viewModel.send(.likeMovie)
        
        // THEN
        let afterFirstToggle = viewModel.state.movie?.isFavorite
        XCTAssertTrue(afterFirstToggle ?? false)
        
        // WHEN - toggle again
        viewModel.send(.likeMovie)
        
        // THEN
        let afterSecondToggle = viewModel.state.movie?.isFavorite
        XCTAssertFalse(afterSecondToggle ?? true)
    }
    
    // MARK: - Computed Properties Tests
    
    @MainActor
    func testMovieGenresWhenDetailIsNil() async {
        // GIVEN
        let movie = makeMovieEntity(id: 1, title: "Iron Man")
        let mockRepo = MockMovieRepository()
        let viewModel = DetailMovieViewModel(repository: mockRepo, movie: movie)
        
        // WHEN / THEN
        let genres = viewModel.movieGenres
        XCTAssertEqual(genres, "")
    }
    
    @MainActor
    func testYoutubeURLWithNonYouTubeVideo() async {
        // GIVEN
        let movie = makeMovieEntity(id: 1, title: "Iron Man")
        let mockDetail = makeMovieDetailDTO(
            videos: MovieVideoResponseDTO(
                results: [
                    MovieVideoDTO(
                        id: "1",
                        key: "somekey",
                        name: "Vimeo Trailer",
                        site: "Vimeo"
                    )
                ]
            )
        )
        let mockRepo = MockMovieRepository(
            detailResult: .success(mockDetail)
        )
        let viewModel = DetailMovieViewModel(repository: mockRepo, movie: movie)
        
        // WHEN
        await viewModel.fetchMovieDetail()
        
        // THEN
        let url = viewModel.youtubeURL
        XCTAssertEqual(url, "")
    }
    
    @MainActor
    func testYoutubeURLWithNoVideos() async {
        // GIVEN
        let movie = makeMovieEntity(id: 1, title: "Iron Man")
        let mockDetail = makeMovieDetailDTO(
            videos: MovieVideoResponseDTO(results: [])
        )
        let mockRepo = MockMovieRepository(
            detailResult: .success(mockDetail)
        )
        let viewModel = DetailMovieViewModel(repository: mockRepo, movie: movie)
        
        // WHEN
        await viewModel.fetchMovieDetail()
        
        // THEN
        let url = viewModel.youtubeURL
        XCTAssertEqual(url, "")
    }
    
    @MainActor
    func testShowTrailerBinding() async {
        // GIVEN
        let movie = makeMovieEntity(id: 1, title: "Iron Man")
        let mockRepo = MockMovieRepository()
        let viewModel = DetailMovieViewModel(repository: mockRepo, movie: movie)
        
        // WHEN
        let binding = viewModel.showTrailerBinding
        
        // THEN
        XCTAssertFalse(binding.wrappedValue)
        
        // WHEN - set to true
        binding.wrappedValue = true
        
        // THEN
        let afterTrue = viewModel.state.showTrailer
        XCTAssertTrue(afterTrue)
        
        // WHEN - set to false
        binding.wrappedValue = false
        
        // THEN
        let afterFalse = viewModel.state.showTrailer
        XCTAssertFalse(afterFalse)
    }
}
