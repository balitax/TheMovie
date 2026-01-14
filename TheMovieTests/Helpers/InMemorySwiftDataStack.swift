//
//  InMemorySwiftDataStack.swift
//  TheMovie
//
//  Created by Aguscahyo on 14/01/26.
//

import SwiftData
@testable import TheMovie

func makeInMemoryContainer() throws -> ModelContainer {

    let schema = Schema([
        MovieEntity.self
    ])

    let configuration = ModelConfiguration(
        isStoredInMemoryOnly: true
    )

    return try ModelContainer(
        for: schema,
        configurations: configuration
    )
}
