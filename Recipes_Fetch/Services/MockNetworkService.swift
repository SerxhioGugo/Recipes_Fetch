//
//  MockNetworkService.swift
//  Recipes_Fetch
//
//  Created by Serxhio Gugo on 2/17/25.
//

import Foundation

class MockNetworkService: NetworkServiceProtocol {
    
    var result: Result<RecipesResponse, Error>
    
    init(result: Result<RecipesResponse, Error>) {
        self.result = result
    }
    func request<T: Codable>(
        url: URL,
        method: HTTPMethod,
        headers: [String : String]?,
        body: Data?,
        decoder: JSONDecoder
    ) async throws -> T {
        switch result {
        case .success(let response):
            guard let castResponse = response as? T else {
                fatalError("Debug: type mismatch, expected \(T.self) but got \(type(of: response))")
            }
            return castResponse
        case .failure(let error):
            throw error
        }
    }
    
}
