//
//  NetworkServiceError.swift
//  Recipes_Fetch
//
//  Created by Serxhio Gugo on 2/17/25.
//

import Foundation

public enum NetworkServiceError: Error, LocalizedError {
    case invalidURL(String)
    case invalidResponse
    case invalidStatusCode(Int)
    case decodingError(Error)
    case networkError(Error)
    case timeout
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL(let urlString):
            return "Invalid URL: \(urlString)"
        case .invalidResponse:
            return "Invalid response from the server."
        case .invalidStatusCode(let code):
            return "Request failed with status code: \(code)."
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .networkError(let error):
            if let urlError = error as? URLError, urlError.code == .timedOut {
                return "The request timed out."
            }
            return "Network error: \(error.localizedDescription)"
        case .timeout:
            return "The request timed out."
        }
    }
}
