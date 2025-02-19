//
//  RecipeViewModelTests.swift
//  Recipes_Fetch
//
//  Created by Serxhio Gugo on 2/18/25.
//


import XCTest
@testable import Recipes_Fetch  // Replace with your module name

@MainActor
final class RecipeViewModelTests: XCTestCase {
    
    // Helper: Create a dummy recipe for testing.
    var mockRecipe: Recipe {
        Recipe(
            cuisine: "Italian",
            name: "Test Recipe",
            photoURLLarge: "https://example.com/large.jpg",
            photoURLSmall: "https://example.com/small.jpg",
            sourceURL: nil,
            uuid: "dummy-uuid-1234",
            youtubeURL: nil
        )
    }
    
    // Testing successful fetching of recipes
    func testFetchRecipesSuccess() async throws {
        // Given
        let dummyResponse = RecipesResponse(recipes: [mockRecipe])
        let mockService = MockNetworkService(result: .success(dummyResponse))
        let viewModel = RecipeViewModel(networkService: mockService)
        
        // When
        viewModel.fetchRecipes()
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        // Then        
        XCTAssertEqual(viewModel.recipes.count, 1, "One recipe is expected after fetch")
        XCTAssertEqual(viewModel.recipes.first?.name, mockRecipe.name, "The name of the recipe we just fetched should match the mock recipe name.")
                
        XCTAssertEqual(viewModel.groupedRecipes["Italian"]?.first, mockRecipe, "The grouped recipes should include the mock recipe (Italian).")
        XCTAssertTrue(viewModel.cuisineFilters.contains("All Recipes"), "'All Recipes' filter should be present.")
        XCTAssertTrue(viewModel.cuisineFilters.contains("Italian"), "The cuisine filter should include 'Italian'.")
    }
    
    // Testing failure fetching recipes.
    func testFetchRecipesFailure() async throws {
        // Given
        let error = NetworkServiceError.invalidResponse
        let mockService = MockNetworkService(result: .failure(error))
        let viewModel = RecipeViewModel(networkService: mockService)
        
        // When
        viewModel.fetchRecipes()
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        // Then
        XCTAssertFalse(viewModel.isLoading, "ViewModel should not be loading after a failed fetch.")
        XCTAssertTrue(viewModel.recipes.isEmpty, "The recipes array should be empty when fetching fails.")
    }
}
