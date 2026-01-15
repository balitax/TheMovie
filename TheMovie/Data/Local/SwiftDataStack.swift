//
//  SwiftDataStack.swift
//  TheMovie
//
//  Created by Aguscahyo on 14/01/26.
//

import SwiftData

struct SwiftDataStack {

    static func makeContainer() -> ModelContainer {
        let schema = Schema([
            MovieEntity.self,
            FavoriteMovieEntity.self
        ])
        return try! ModelContainer(for: schema)
    }
}
