//
//  APIClient.swift
//  TheMovie
//
//  Created by Aguscahyo on 14/01/26.
//

import Alamofire

final class APIClient: NetworkService {

    func request<T: Decodable>(_ endpoint: MovieEndpoint) async throws -> T {

        let url = APIConfig.baseURL + endpoint.path

        let response = await AF.request(
            url,
            parameters: endpoint.parameters
        )
        .serializingDecodable(T.self)
        .response

        switch response.result {
        case .success(let value):
            return value
        case .failure(let error):
            throw NetworkError.unknown(error)
        }
    }
}
