//
//  MovieDTO.swift
//  TheMovie
//
//  Created by Aguscahyo on 14/01/26.
//

import Foundation

// MARK: - MovieDTO
struct MovieDTO: Codable {
    let page: Int
    let results: [MovieResult]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct MovieResult: Codable {
    let adult: Bool
    let backdropPath: String?
    let genreIDS: [Int]
    let id: Int
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let releaseDate: String?
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

extension MovieResult {

    func toEntity() -> MovieEntity {
        MovieEntity(
            id: id,
            title: title,
            overview: overview,
            posterPath: posterPath ?? "",
            backdropPath: backdropPath ?? "",
            releaseDate: releaseDate ?? "",
            popularity: popularity,
            voteAverage: voteAverage,
            voteCount: voteCount,
            adult: adult,
            video: video,
            originalTitle: originalTitle,
            originalLanguage: originalLanguage,
            genreIDs: genreIDS
        )
    }
}
