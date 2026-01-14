//
//  MovieEntityDummy.swift
//  TheMovie
//
//  Created by Aguscahyo on 14/01/26.
//

@testable import TheMovie

func makeMovieEntity(
    id: Int = 1,
    title: String = "Iron Man"
) -> MovieEntity {
    MovieEntity(
        id: id,
        title: title,
        overview: "Marvel movie",
        posterPath: "",
        backdropPath: "",
        releaseDate: "2008-05-02",
        popularity: 10,
        voteAverage: 8.5,
        voteCount: 1000,
        adult: false,
        video: false,
        originalTitle: title,
        originalLanguage: "en",
        genreIDs: [28]
    )
}

