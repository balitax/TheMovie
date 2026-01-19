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

    func fetchMovie(id: Int) throws -> MovieEntity? {
        let descriptor = FetchDescriptor<MovieEntity>(predicate: #Predicate<MovieEntity> { $0.id == id })
        return try context.fetch(descriptor).first
    }

    func save(_ movies: [MovieEntity]) throws {
        movies.forEach { context.insert($0) }
        try context.save()
    }

    func clear() throws {
        try context.delete(model: MovieEntity.self)
    }

    // MARK: - Favorites
    func fetchFavorites() throws -> [FavoriteMovieEntity] {
        try context.fetch(FetchDescriptor<FavoriteMovieEntity>(sortBy: [SortDescriptor(\.createdAt, order: .reverse)]))
    }

    func saveFavorite(_ favorite: FavoriteMovieEntity) throws {
        context.insert(favorite)
        try context.save()
    }

    func deleteFavorite(id: Int) throws {
        try context.delete(model: FavoriteMovieEntity.self, where: #Predicate<FavoriteMovieEntity> { $0.id == id })
        try context.save()
    }

    func isFavorite(id: Int) -> Bool {
        let descriptor = FetchDescriptor<FavoriteMovieEntity>(predicate: #Predicate<FavoriteMovieEntity> { $0.id == id })
        let count = (try? context.fetchCount(descriptor)) ?? 0
        return count > 0
    }
}
