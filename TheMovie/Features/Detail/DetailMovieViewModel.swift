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
    var showTrailer = false
    var showPlayInfo = false
    var headerHeight: CGFloat = 420
}

// MARK: - ACTION
enum DetailMovieAction {
    case onAppear
    case showTrailer
    case showPlayInfo
    case likeMovie
}

// MARK: - EVENT
enum DetailMovieEvent { }

@Observable
final class DetailMovieViewModel {
    
    // MARK: Variables
    private(set) var state = DetailMovieState()
    @ObservationIgnored let event = PassthroughSubject<DetailMovieEvent, Never>()
    
    init(movie: MovieEntity?) {
        self.state.movie = movie
    }
    
    func send(_ action: DetailMovieAction) {
        switch action {
        case .onAppear: break
        case .showTrailer:
            state.showTrailer.toggle()
        case .showPlayInfo:
            state.showPlayInfo.toggle()
        case .likeMovie:
            state.movie?.isFavorite.toggle()
        }
    }
}

extension DetailMovieViewModel {
    var showTrailerBinding: Binding<Bool> {
        Binding(
            get: { self.state.showTrailer },
            set: { _ in self.send(.showTrailer) }
        )
    }
    
    var showPlayMovieBinding: Binding<Bool> {
        Binding(
            get: { self.state.showPlayInfo },
            set: { _ in self.send(.showPlayInfo) }
        )
    }
}
