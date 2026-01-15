//
//  InMemorySwiftDataStack.swift
//  TheMovie
//
//  Created by Aguscahyo on 14/01/26.
//

import SwiftData
@testable import TheMovie

@MainActor
final class TestModelContainer {
    static let shared: ModelContainer = {
        let schema = Schema([
            MovieEntity.self,
            FavoriteMovieEntity.self
        ])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        return try! ModelContainer(for: schema, configurations: configuration)
    }()
    
    static func makeFreshContext() -> ModelContext {
        ModelContext(shared)
    }
}

@MainActor
func makeInMemoryContainer() throws -> ModelContainer {
    return TestModelContainer.shared
}
