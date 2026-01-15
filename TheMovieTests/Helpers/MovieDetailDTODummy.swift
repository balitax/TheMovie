//
//  MovieDetailDTODummy.swift
//  TheMovie
//
//  Created by Aguscahyo on 15/01/26.
//

@testable import TheMovie

func makeMovieDetailDTO(
    genres: [GenreDTO] = [
        GenreDTO(id: 28, name: "Action"),
        GenreDTO(id: 12, name: "Adventure")
    ],
    originCountry: [String] = ["US"],
    productionCompanies: [ProductionCompanyDTO] = [
        ProductionCompanyDTO(id: 1, name: "Marvel Studios")
    ],
    productionCountries: [ProductionCountryDTO] = [
        ProductionCountryDTO(name: "United States of America")
    ],
    spokenLanguages: [SpokenLanguageDTO] = [
        SpokenLanguageDTO(name: "English")
    ],
    videos: MovieVideoResponseDTO = MovieVideoResponseDTO(
        results: [
            MovieVideoDTO(
                id: "1",
                key: "8hYlB38asDY",
                name: "Official Trailer",
                site: "YouTube"
            )
        ]
    )
) -> MovieDetailDTO {
    MovieDetailDTO(
        genres: genres,
        originCountry: originCountry,
        productionCompanies: productionCompanies,
        productionCountries: productionCountries,
        spokenLanguages: spokenLanguages,
        videos: videos
    )
}
