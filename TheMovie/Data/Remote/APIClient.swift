//
//  APIClient.swift
//  TheMovie
//
//  Created by Aguscahyo on 14/01/26.
//

import Foundation
import Alamofire

import Alamofire

final class APIClient: NetworkService {

    static let shared = APIClient()
    private init() {}

    func request<T: Decodable>(_ url: String) async throws -> T {

        let response = await AF.request(url)
            .serializingDecodable(T.self)
            .response

        switch response.result {
        case .success(let value):
            return value

        case .failure(let error):
            if let statusCode = response.response?.statusCode {
                throw NetworkError.server(statusCode)
            } else {
                throw NetworkError.unknown(error)
            }
        }
    }
}

