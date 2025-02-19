//
//  RecipesResponse.swift
//  Recipes_Fetch
//
//  Created by Serxhio Gugo on 2/17/25.
//

import Foundation

// MARK: - RecipesResponse
struct RecipesResponse: Codable {
    let recipes: [Recipe]
}

// MARK: - Recipe
struct Recipe: Codable, Identifiable, Equatable {
    let cuisine, name: String
    let photoURLLarge: String
    let photoURLSmall: String
    let sourceURL: String?
    let uuid: String
    let youtubeURL: String?
    var id: String { uuid }

    enum CodingKeys: String, CodingKey {
        case cuisine
        case name
        case photoURLLarge = "photo_url_large"
        case photoURLSmall = "photo_url_small"
        case sourceURL = "source_url"
        case uuid
        case youtubeURL = "youtube_url"
    }
}
