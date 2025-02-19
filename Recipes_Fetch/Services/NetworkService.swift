//
//  NetworkService.swift
//  Recipes_Fetch
//
//  Created by Serxhio Gugo on 2/17/25.
//

import Foundation

public enum HTTPMethod: String {
    case GET, POST, PUT, DELETE, PATCH
    
    var stringValue: String {
        switch self {
        case .GET: return "GET"
        case .POST: return "POST"
        case .PUT: return "PUT"
        case .DELETE: return "DELETE"
        case .PATCH: return "PATCH"
        }
    }
}

protocol NetworkServiceProtocol {
    func request<T: Codable>(
        url: URL,
        method: HTTPMethod,
        headers: [String: String]?,
        body: Data?,
        decoder: JSONDecoder
    ) async throws -> T
}

extension NetworkServiceProtocol {
    func request<T: Codable>(url: URL) async throws -> T {
        try await request(
            url: url,
            method: .GET,
            headers: nil,
            body: nil,
            decoder: JSONDecoder()
        )
    }
}

final class NetworkService: NetworkServiceProtocol {
    
    func request<T: Codable>(
        url: URL,
        method: HTTPMethod = .GET,
        headers: [String: String]? = nil,
        body: Data? = nil,
        decoder: JSONDecoder = JSONDecoder()
    ) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = method.stringValue
        request.httpBody = body
        request.timeoutInterval = 30.0
        
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkServiceError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkServiceError.invalidStatusCode(httpResponse.statusCode)
            }
            
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                throw NetworkServiceError.decodingError(error)
            }
        } catch let urlError as URLError {
            if urlError.code == .timedOut {
                throw NetworkServiceError.timeout
            }
            throw NetworkServiceError.networkError(urlError)
        } catch {
            throw NetworkServiceError.networkError(error)
        }
    }
}
