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
    
    func testInitialization() async {
        // GIVEN
        let movie = await MainActor.run { makeMovieEntity(id: 1, title: "Iron Man") }
        let mockRepo = MockMovieRepository()
        
        // WHEN
        let viewModel = await MainActor.run { DetailMovieViewModel(repository: mockRepo, movie: movie) }
        
        // THEN
        let state = await MainActor.run { viewModel.state }
        let stateMovie = await state.movie
        let stateDetail = await state.detail
        let showTrailer = await state.showTrailer
        let headerHeight = await state.headerHeight

        let movieId = stateMovie?.id
        let movieTitle = stateMovie?.title
        
        XCTAssertNotNil(stateMovie)
        XCTAssertEqual(movieId, 1)
        XCTAssertEqual(movieTitle, "Iron Man")
        XCTAssertNil(stateDetail)
        XCTAssertFalse(showTrailer)
        XCTAssertEqual(headerHeight, 420)
    }
    
    func testInitializationWithNilMovie() async {
        // GIVEN
        let mockRepo = MockMovieRepository()
        
        // WHEN
        let viewModel = await MainActor.run { DetailMovieViewModel(repository: mockRepo, movie: nil) }
        
        // THEN
        let state = await MainActor.run { viewModel.state }
        let stateMovie = await state.movie
        let stateDetail = await state.detail

        XCTAssertNil(stateMovie)
        XCTAssertNil(stateDetail)
    }
    
    // MARK: - Fetch Movie Detail Tests
    
    func testFetchMovieDetailSuccess() async {
        // GIVEN
        let movie = await MainActor.run { makeMovieEntity(id: 1, title: "Iron Man") }
        let mockDetail = makeMovieDetailDTO()
        let mockRepo = MockMovieRepository(
            detailResult: .success(mockDetail)
        )
        let viewModel = await MainActor.run { DetailMovieViewModel(repository: mockRepo, movie: movie) }
        
        // WHEN
        await viewModel.fetchMovieDetail()
        
        // THEN
        let detail = await MainActor.run { viewModel.state.detail }
        let genres = await detail?.genres
        let genresCount = genres?.count
        let firstGenreName = await genres?.first?.name
        let companies = await detail?.productionCompanies
        let firstCompanyName = await companies?.first?.name
        
        XCTAssertNotNil(detail)
        XCTAssertEqual(genresCount, 2)
        XCTAssertEqual(firstGenreName, "Action")
        XCTAssertEqual(firstCompanyName, "Marvel Studios")
    }
    
    func testFetchMovieDetailFailure() async {
        // GIVEN
        enum DummyError: Error { case failed }
        let movie = await MainActor.run { makeMovieEntity(id: 1, title: "Iron Man") }
        let mockRepo = MockMovieRepository(
            detailResult: .failure(DummyError.failed)
        )
        let viewModel = await MainActor.run { DetailMovieViewModel(repository: mockRepo, movie: movie) }
        
        // WHEN
        await viewModel.fetchMovieDetail()
        
        // THEN
        let detail = await MainActor.run { viewModel.state.detail }
        XCTAssertNil(detail)
    }
    
    func testFetchMovieDetailWithNilMovie() async {
        // GIVEN
        let mockRepo = MockMovieRepository()
        let viewModel = await MainActor.run { DetailMovieViewModel(repository: mockRepo, movie: nil) }
        
        // WHEN
        await viewModel.fetchMovieDetail()
        
        // THEN
        let detail = await MainActor.run { viewModel.state.detail }
        XCTAssertNil(detail)
    }
    
    // MARK: - Action Tests
    
    func testOnAppearAction() async {
        // GIVEN
        let movie = await MainActor.run { makeMovieEntity(id: 1, title: "Iron Man") }
        let mockDetail = makeMovieDetailDTO()
        let mockRepo = MockMovieRepository(
            detailResult: .success(mockDetail)
        )
        let viewModel = await MainActor.run { DetailMovieViewModel(repository: mockRepo, movie: movie) }
        
        // WHEN
        await MainActor.run { viewModel.send(.onAppear) }
        
        // Wait a bit for async task to complete
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // THEN
        let detail = await MainActor.run { viewModel.state.detail }
        XCTAssertNotNil(detail)
    }
    
    func testShowTrailerAction() async {
        // GIVEN
        let movie = await MainActor.run { makeMovieEntity(id: 1, title: "Iron Man") }
        let mockRepo = MockMovieRepository()
        let viewModel = await MainActor.run { DetailMovieViewModel(repository: mockRepo, movie: movie) }
        
        // Initial state
        let initialState = await MainActor.run { viewModel.state.showTrailer }
        XCTAssertFalse(initialState)
        
        // WHEN
        await MainActor.run { viewModel.send(.showTrailer) }
        
        // THEN
        let afterFirstToggle = await MainActor.run { viewModel.state.showTrailer }
        XCTAssertTrue(afterFirstToggle)
        
        // WHEN - toggle again
        await MainActor.run { viewModel.send(.showTrailer) }
        
        // THEN
        let afterSecondToggle = await MainActor.run { viewModel.state.showTrailer }
        XCTAssertFalse(afterSecondToggle)
    }
    
    func testLikeMovieAction() async {
        // GIVEN
        let movie = await MainActor.run { makeMovieEntity(id: 1, title: "Iron Man") }
        let mockRepo = MockMovieRepository()
        let viewModel = await MainActor.run { DetailMovieViewModel(repository: mockRepo, movie: movie) }
        
        // Initial state
        let initialFavorite = await MainActor.run { viewModel.state.movie?.isFavorite }
        XCTAssertFalse(initialFavorite ?? true)
        
        // WHEN
        await MainActor.run { viewModel.send(.likeMovie) }
        
        // THEN
        let afterFirstToggle = await MainActor.run { viewModel.state.movie?.isFavorite }
        XCTAssertTrue(afterFirstToggle ?? false)
        
        // WHEN - toggle again
        await MainActor.run { viewModel.send(.likeMovie) }
        
        // THEN
        let afterSecondToggle = await MainActor.run { viewModel.state.movie?.isFavorite }
        XCTAssertFalse(afterSecondToggle ?? true)
    }
    
    // MARK: - Computed Properties Tests
    
    func testMovieGenres() async {
        // GIVEN
        let movie = await MainActor.run { makeMovieEntity(id: 1, title: "Iron Man") }
        let mockDetail = makeMovieDetailDTO(
            genres: [
                GenreDTO(id: 28, name: "Action"),
                GenreDTO(id: 12, name: "Adventure"),
                GenreDTO(id: 878, name: "Science Fiction")
            ]
        )
        let mockRepo = MockMovieRepository(
            detailResult: .success(mockDetail)
        )
        let viewModel = await MainActor.run { DetailMovieViewModel(repository: mockRepo, movie: movie) }
        
        // WHEN
        await viewModel.fetchMovieDetail()
        
        // THEN
        let genres = await MainActor.run { viewModel.movieGenres }
        XCTAssertEqual(genres, "Action, Adventure, Science Fiction")
    }
    
    func testMovieGenresWhenDetailIsNil() async {
        // GIVEN
        let movie = await MainActor.run { makeMovieEntity(id: 1, title: "Iron Man") }
        let mockRepo = MockMovieRepository()
        let viewModel = await MainActor.run { DetailMovieViewModel(repository: mockRepo, movie: movie) }
        
        // WHEN / THEN
        let genres = await MainActor.run { viewModel.movieGenres }
        XCTAssertEqual(genres, "")
    }
    
    func testMovieProductionCountries() async {
        // GIVEN
        let movie = await MainActor.run { makeMovieEntity(id: 1, title: "Iron Man") }
        let mockDetail = makeMovieDetailDTO(
            productionCountries: [
                ProductionCountryDTO(name: "United States of America"),
                ProductionCountryDTO(name: "Canada")
            ]
        )
        let mockRepo = MockMovieRepository(
            detailResult: .success(mockDetail)
        )
        let viewModel = await MainActor.run { DetailMovieViewModel(repository: mockRepo, movie: movie) }
        
        // WHEN
        await viewModel.fetchMovieDetail()
        
        // THEN
        let countries = await MainActor.run { viewModel.movieProductionCountries }
        XCTAssertEqual(countries, "United States of America, Canada")
    }
    
    func testMovieLanguages() async {
        // GIVEN
        let movie = await MainActor.run { makeMovieEntity(id: 1, title: "Iron Man") }
        let mockDetail = makeMovieDetailDTO(
            spokenLanguages: [
                SpokenLanguageDTO(name: "English"),
                SpokenLanguageDTO(name: "Spanish")
            ]
        )
        let mockRepo = MockMovieRepository(
            detailResult: .success(mockDetail)
        )
        let viewModel = await MainActor.run { DetailMovieViewModel(repository: mockRepo, movie: movie) }
        
        // WHEN
        await viewModel.fetchMovieDetail()
        
        // THEN
        let languages = await MainActor.run { viewModel.movieLanguages }
        XCTAssertEqual(languages, "English, Spanish")
    }
    
    func testMovieProductionCompanies() async {
        // GIVEN
        let movie = await MainActor.run { makeMovieEntity(id: 1, title: "Iron Man") }
        let mockDetail = makeMovieDetailDTO(
            productionCompanies: [
                ProductionCompanyDTO(id: 1, name: "Marvel Studios"),
                ProductionCompanyDTO(id: 2, name: "Paramount Pictures")
            ]
        )
        let mockRepo = MockMovieRepository(
            detailResult: .success(mockDetail)
        )
        let viewModel = await MainActor.run { DetailMovieViewModel(repository: mockRepo, movie: movie) }
        
        // WHEN
        await viewModel.fetchMovieDetail()
        
        // THEN
        let companies = await MainActor.run { viewModel.movieProductionCompanies }
        XCTAssertEqual(companies, "Marvel Studios, Paramount Pictures")
    }
    
    func testYoutubeURL() async {
        // GIVEN
        let movie = await MainActor.run { makeMovieEntity(id: 1, title: "Iron Man") }
        let mockDetail = makeMovieDetailDTO(
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
        let viewModel = await MainActor.run { DetailMovieViewModel(repository: mockRepo, movie: movie) }
        
        // WHEN
        await viewModel.fetchMovieDetail()
        
        // THEN
        let url = await MainActor.run { viewModel.youtubeURL }
        XCTAssertEqual(url, "https://www.youtube.com/watch?v=8hYlB38asDY")
    }
    
    func testYoutubeURLWithNonYouTubeVideo() async {
        // GIVEN
        let movie = await MainActor.run { makeMovieEntity(id: 1, title: "Iron Man") }
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
        let viewModel = await MainActor.run { DetailMovieViewModel(repository: mockRepo, movie: movie) }
        
        // WHEN
        await viewModel.fetchMovieDetail()
        
        // THEN
        let url = await MainActor.run { viewModel.youtubeURL }
        XCTAssertEqual(url, "")
    }
    
    func testYoutubeURLWithNoVideos() async {
        // GIVEN
        let movie = await MainActor.run { makeMovieEntity(id: 1, title: "Iron Man") }
        let mockDetail = makeMovieDetailDTO(
            videos: MovieVideoResponseDTO(results: [])
        )
        let mockRepo = MockMovieRepository(
            detailResult: .success(mockDetail)
        )
        let viewModel = await MainActor.run { DetailMovieViewModel(repository: mockRepo, movie: movie) }
        
        // WHEN
        await viewModel.fetchMovieDetail()
        
        // THEN
        let url = await MainActor.run { viewModel.youtubeURL }
        XCTAssertEqual(url, "")
    }
    
    func testShowTrailerBinding() async {
        // GIVEN
        let movie = await MainActor.run { makeMovieEntity(id: 1, title: "Iron Man") }
        let mockRepo = MockMovieRepository()
        let viewModel = await MainActor.run { DetailMovieViewModel(repository: mockRepo, movie: movie) }
        
        // WHEN
        let binding = await MainActor.run { viewModel.showTrailerBinding }
        
        // THEN
        XCTAssertFalse(binding.wrappedValue)
        
        // WHEN - set to true
        binding.wrappedValue = true
        
        // THEN
        let afterTrue = await MainActor.run { viewModel.state.showTrailer }
        XCTAssertTrue(afterTrue)
        
        // WHEN - set to false
        binding.wrappedValue = false
        
        // THEN
        let afterFalse = await MainActor.run { viewModel.state.showTrailer }
        XCTAssertFalse(afterFalse)
    }
}
