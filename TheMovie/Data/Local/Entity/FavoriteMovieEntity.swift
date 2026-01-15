//
//  FavoriteMovieEntity.swift
//  TheMovie
//
//  Created by Antigravity on 15/01/26.
//

import Foundation
import SwiftData

@Model
final class FavoriteMovieEntity {
    @Attribute(.unique) var id: Int
    var title: String
    var overview: String
    var posterPath: String
    var releaseDate: String
    var popularity: Double
    var voteAverage: Double
    var voteCount: Int
    var createdAt: Date

    init(
        id: Int,
        title: String,
        overview: String,
        posterPath: String,
        releaseDate: String,
        popularity: Double,
        voteAverage: Double,
        voteCount: Int,
        createdAt: Date = .now
    ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.popularity = popularity
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.createdAt = createdAt
    }
}

extension FavoriteMovieEntity {
    func toMovieEntity() -> MovieEntity {
        MovieEntity(
            id: id,
            title: title,
            overview: overview,
            posterPath: posterPath,
            releaseDate: releaseDate,
            popularity: popularity,
            voteAverage: voteAverage,
            voteCount: voteCount,
            isFavorite: true
        )
    }
}
