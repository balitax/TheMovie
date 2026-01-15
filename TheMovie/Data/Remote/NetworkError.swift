//
//  NetworkError.swift
//  TheMovie
//
//  Created by Aguscahyo on 14/01/26.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case server(Int)
    case decoding(Error)
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .server(let code):
            return "Server error with status code: \(code)"
        case .decoding(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .unknown(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}
