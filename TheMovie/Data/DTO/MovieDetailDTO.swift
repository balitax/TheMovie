//
//  MovieDetailDTO.swift
//  TheMovie
//
//  Created by Aguscahyo on 15/01/26.
//

import Foundation

// MARK: - MovieDetailDTO
struct MovieDetailDTO: Codable {

    let genres: [GenreDTO]
    let originCountry: [String]
    let productionCompanies: [ProductionCompanyDTO]
    let productionCountries: [ProductionCountryDTO]
    let spokenLanguages: [SpokenLanguageDTO]
    let videos: MovieVideoResponseDTO

    enum CodingKeys: String, CodingKey {
        case genres
        case originCountry = "origin_country"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case spokenLanguages = "spoken_languages"
        case videos
    }
}

// MARK: - Genre
struct GenreDTO: Codable, Identifiable {
    let id: Int
    let name: String
}

// MARK: - Production Company
struct ProductionCompanyDTO: Codable, Identifiable {
    let id: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}

// MARK: - Production Country
struct ProductionCountryDTO: Codable {
    let name: String

    enum CodingKeys: String, CodingKey {
        case name
    }
}

// MARK: - Spoken Language
struct SpokenLanguageDTO: Codable {
    let name: String

    enum CodingKeys: String, CodingKey {
        case name
    }
}

struct MovieVideoResponseDTO: Codable {
    let results: [MovieVideoDTO]
}

// MARK: Movies
struct MovieVideoDTO: Codable, Identifiable {

    let id: String
    let key: String
    let name: String
    let site: String

    enum CodingKeys: String, CodingKey {
        case id
        case key
        case name
        case site
    }

    var youtubeURL: String {
        guard site == "YouTube" else { return "" }
        return "https://www.youtube.com/watch?v=\(key)"
    }
}
