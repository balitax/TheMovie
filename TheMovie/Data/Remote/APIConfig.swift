//
//  APIConfig.swift
//  TheMovie
//
//  Created by Aguscahyo on 14/01/26.
//

import Foundation

enum APIConfig {
    static var baseURL: String {
        return Bundle.main.object(forInfoDictionaryKey: "TMDB_BASE_URL") as? String ?? ""
    }
    
    static var apiKey: String {
        return Bundle.main.object(forInfoDictionaryKey: "TMDB_API_KEY") as? String ?? ""
    }
    
    static let language = "en-US"
}
