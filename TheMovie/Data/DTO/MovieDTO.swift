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
    let id: Int
    let overview: String?
    let popularity: Double?
    let posterPath: String?
    let releaseDate: String?
    let title: String?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

extension MovieResult {

    func toEntity(existing: MovieEntity? = nil) -> MovieEntity {
        MovieEntity(
            id: id,
            title: title ?? "",
            overview: overview ?? "",
            posterPath: posterPath ?? "",
            releaseDate: releaseDate ?? "",
            popularity: popularity ?? 0,
            voteAverage: voteAverage ?? 0,
            voteCount: voteCount ?? 0,
            isFavorite: existing?.isFavorite ?? false
        )
    }
}
