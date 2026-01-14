//
//  MockAPIClient.swift
//  TheMovie
//
//  Created by Aguscahyo on 14/01/26.
//

@testable import TheMovie

final class MockAPIClient: NetworkService {

    /// Simpan response per endpoint
    private let result: Result<Any, Error>

    init(result: Result<Any, Error>) {
        self.result = result
    }

    func request<T: Decodable>(
        _ endpoint: MovieEndpoint
    ) async throws -> T {

        switch result {
        case .success(let value):
            guard let typedValue = value as? T else {
                fatalError("❌ MockAPIClient: Type mismatch for \(T.self)")
            }
            return typedValue

        case .failure(let error):
            throw error
        }
    }
}
