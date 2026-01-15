//
//  DetailMovieViewModel.swift
//  TheMovie
//
//  Created by Aguscahyo on 15/01/26.
//

import Foundation
import SwiftUI
import Combine

// MARK: - STATE
struct DetailMovieState {
    var movie: MovieEntity?
    var detail: MovieDetailDTO?
    var showTrailer = false
    var headerHeight: CGFloat = 420
}

// MARK: - ACTION
enum DetailMovieAction {
    case onAppear
    case showTrailer
    case likeMovie
}

// MARK: - EVENT
enum DetailMovieEvent { }

@Observable
final class DetailMovieViewModel {
    
    // MARK: Variables
    private(set) var state = DetailMovieState()
    @ObservationIgnored let event = PassthroughSubject<DetailMovieEvent, Never>()
    
    // MARK: - Dependencies
    private let repository: MovieRepositoryProtocol

    init(repository: MovieRepositoryProtocol, movie: MovieEntity?) {
        self.repository = repository
        self.state.movie = movie
    }

    func send(_ action: DetailMovieAction) {
        switch action {
        case .onAppear:
            Task {
                await fetchMovieDetail()
            }
        case .showTrailer:
            state.showTrailer.toggle()
        case .likeMovie:
            state.movie?.isFavorite.toggle()
        }
    }
}

extension DetailMovieViewModel {

    func fetchMovieDetail() async {
        guard let movieId = state.movie?.id else { return }
        state.detail = try? await repository.getMovieDetail(id: movieId)
    }

    var movieGenres: String {
        return state.detail?.genres.compactMap { $0.name }.joined(separator: ", ") ?? ""
    }
    
    var movieProductionCountries: String {
        return state.detail?.productionCountries.compactMap { $0.name }.joined(separator: ", ") ?? ""
    }
    
    var movieLanguages: String {
        return state.detail?.spokenLanguages.compactMap { $0.name }.joined(separator: ", ") ?? ""
    }
    
    var movieProductionCompanies: String {
        return state.detail?.productionCompanies.compactMap { $0.name }.joined(separator: ", ") ?? ""
    }

    var youtubeURL: String {
        let trailerURL = state.detail?.videos.results.first { $0.site == "YouTube" }?.youtubeURL ?? ""
        return trailerURL
    }

    var showTrailerBinding: Binding<Bool> {
        Binding(
            get: { self.state.showTrailer },
            set: { _ in self.send(.showTrailer) }
        )
    }
}
