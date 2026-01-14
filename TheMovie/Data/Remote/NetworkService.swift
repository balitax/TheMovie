//
//  NetworkService.swift
//  TheMovie
//
//  Created by Aguscahyo on 14/01/26.
//

import Foundation

protocol NetworkService {
    func request<T: Decodable>(_ endpoint: MovieEndpoint) async throws -> T
}
