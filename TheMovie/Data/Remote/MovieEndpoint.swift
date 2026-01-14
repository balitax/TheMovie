//
//  MovieEndpoint.swift
//  TheMovie
//
//  Created by Aguscahyo on 14/01/26.
//

import Alamofire

enum MovieEndpoint {

    case popular(page: Int)
    case search(query: String, page: Int)

    var path: String {
        switch self {
        case .popular:
            return "/movie/popular"
        case .search:
            return "/search/movie"
        }
    }

    var parameters: [String: Any] {
        var params: [String: Any] = [
            "api_key": APIConfig.apiKey,
            "language": APIConfig.language
        ]

        switch self {
        case .popular(let page):
            params["page"] = page
        case .search(let query, let page):
            params["query"] = query
            params["page"] = page
            params["include_adult"] = false
        }

        return params
    }
}
