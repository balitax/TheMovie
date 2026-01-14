//
//  NetworkError.swift
//  TheMovie
//
//  Created by Aguscahyo on 14/01/26.
//

import Foundation

enum NetworkError: Error {
    case server(Int)
    case decoding(Error)
    case unknown(Error)
}
