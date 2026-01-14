//
//  MovieLocalDataSource.swift
//  TheMovie
//
//  Created by Aguscahyo on 14/01/26.
//

import Foundation
import SwiftData

final class MovieLocalDataSource {

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func fetchMovies() throws -> [MovieEntity] {
        try context.fetch(FetchDescriptor<MovieEntity>())
    }

    func save(_ movies: [MovieEntity]) throws {
        movies.forEach { context.insert($0) }
        try context.save()
    }

    func clear() throws {
        try context.delete(model: MovieEntity.self)
    }
}
