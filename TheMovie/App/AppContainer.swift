//
//  AppContainer.swift
//  TheMovie
//
//  Created by Aguscahyo on 15/01/26.
//

import SwiftData

final class AppContainer {

    // MARK: - Dependencies
    private let modelContext: ModelContext
    private let apiClient: NetworkService

    // MARK: - Init
    init(
        modelContext: ModelContext,
        apiClient: NetworkService = APIClient()
    ) {
        self.modelContext = modelContext
        self.apiClient = apiClient
    }

    // MARK: - Repositories
    func makeMovieRepository() -> MovieRepositoryProtocol {
        let local = MovieLocalDataSource(context: modelContext)
        return MovieRepository(
            remote: apiClient,
            local: local
        )
    }

    // MARK: - ViewModels
    func makeListMovieViewModel() -> ListMovieViewModel {
        ListMovieViewModel(
            repository: makeMovieRepository()
        )
    }
}
