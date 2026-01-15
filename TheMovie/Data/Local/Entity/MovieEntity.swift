//
//  MovieEntity.swift
//  TheMovie
//
//  Created by Aguscahyo on 14/01/26.
//

import Foundation
import SwiftData

@Model
final class MovieEntity {

    // MARK: - Identity
    @Attribute(.unique) var id: Int

    // MARK: - Basic Info
    var title: String
    var overview: String
    var posterPath: String
    var releaseDate: String

    // MARK: - Favorite
    var isFavorite: Bool

    var posterImageURL: URL? {
        return URL(string: "https://image.tmdb.org/t/p/original/\(posterPath)")
    }

    // MARK: - Metadata
    var popularity: Double
    var voteAverage: Double
    var voteCount: Int

    // MARK: - Offline Support
    var cachedAt: Date

    init(
        id: Int,
        title: String,
        overview: String,
        posterPath: String,
        releaseDate: String,
        popularity: Double,
        voteAverage: Double,
        voteCount: Int,
        isFavorite: Bool = false,
        cachedAt: Date = .now
    ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.popularity = popularity
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.isFavorite = isFavorite
        self.cachedAt = cachedAt
    }

    // inject empty data
    init() {
        self.id = 0
        self.title = ""
        self.overview = ""
        self.posterPath = ""
        self.releaseDate = ""
        self.popularity = 0
        self.voteAverage = 0
        self.voteCount = 0
        self.isFavorite = false
        self.cachedAt = .now
    }
}

extension MovieEntity {
    func toggleFavorite() {
        isFavorite.toggle()
    }
}

extension MovieEntity: @unchecked Sendable {}
