//
//  EndpointBuilder.swift
//  Recipes_Fetch
//
//  Created by Serxhio Gugo on 2/17/25.
//

import Foundation

public enum APIEndpoint: String {
    case recipes
    case malformedRecipes
    case emptyDataRecipes
    
    var path: String {
        switch self {
        case .recipes:
            return "recipes.json"
        case .malformedRecipes:
            return "recipes-malformed.json"
        case .emptyDataRecipes:
            return "recipes-empty.json"
        }
    }
}

public struct EndpointBuilder {
    private static let baseUrl = "https://d3jbb8n5wk0qxi.cloudfront.net/"
    
    public static func url(for endpoint: APIEndpoint) throws -> URL {
        let urlString = baseUrl + endpoint.path
        guard let url = URL(string: urlString) else {
            throw NetworkServiceError.invalidURL(urlString)
        }
        return url
    }
}
