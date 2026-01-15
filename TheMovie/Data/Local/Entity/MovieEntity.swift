//
//  MovieEntity.swift
//  TheMovie
//
//  Created by Aguscahyo on 14/01/26.
//

import Foundation
import SwiftData

@Model
final class MovieEntity: Sendable {

    // MARK: - Identity
    @Attribute(.unique) var id: Int

    // MARK: - Basic Info
    var title: String
    var overview: String
    var posterPath: String
    var backdropPath: String
    var releaseDate: String

    var posterImageURL: URL? {
        return URL(string: "https://image.tmdb.org/t/p/original/\(posterPath)")
    }

    // MARK: - Metadata
    var popularity: Double
    var voteAverage: Double
    var voteCount: Int
    var adult: Bool
    var video: Bool

    // MARK: - Extra
    var originalTitle: String
    var originalLanguage: String
    var genreIDs: [Int]

    // MARK: - Offline Support
    var cachedAt: Date

    init(
        id: Int,
        title: String,
        overview: String,
        posterPath: String,
        backdropPath: String,
        releaseDate: String,
        popularity: Double,
        voteAverage: Double,
        voteCount: Int,
        adult: Bool,
        video: Bool,
        originalTitle: String,
        originalLanguage: String,
        genreIDs: [Int],
        cachedAt: Date = .now
    ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.releaseDate = releaseDate
        self.popularity = popularity
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.adult = adult
        self.video = video
        self.originalTitle = originalTitle
        self.originalLanguage = originalLanguage
        self.genreIDs = genreIDs
        self.cachedAt = cachedAt
    }

    // inject empty data
    init() {
        self.id = 0
        self.title = ""
        self.overview = ""
        self.posterPath = ""
        self.backdropPath = ""
        self.releaseDate = ""
        self.popularity = 0
        self.voteAverage = 0
        self.voteCount = 0
        self.adult = false
        self.video = false
        self.originalTitle = ""
        self.originalLanguage = ""
        self.genreIDs = []
        self.cachedAt = .now
    }
}
