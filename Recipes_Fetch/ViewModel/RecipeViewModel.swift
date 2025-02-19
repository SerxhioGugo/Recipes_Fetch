//
//  RecipeViewModel.swift
//  Recipes_Fetch
//
//  Created by Serxhio Gugo on 2/17/25.
//

import Foundation

@MainActor
class RecipeViewModel: ObservableObject {
    
    @Published var recipes: [Recipe] = []
    @Published var isLoading: Bool = false
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchRecipes() {
        Task {
            self.isLoading = true
            do {
                let recipesURL = try EndpointBuilder.url(for: .recipes)
                let recipeResponse: RecipesResponse = try await networkService.request(url: recipesURL)
                self.recipes = recipeResponse.recipes
            } catch let error as NetworkServiceError {
                print("Predefined Error fetching recipes: \(error.localizedDescription)")
            } catch {
                // In case we encounter an error which we're not accounting for in NetworkServiceError
                print("Error fetching recipes: \(error.localizedDescription)")
            }
            self.isLoading = false
        }
    }
    
    // grouped by cuisine
    var groupedRecipes: [String: [Recipe]] {
        Dictionary(grouping: recipes, by: { $0.cuisine })
    }
    
    // all recipes + filtered by cuisine
    var cuisineFilters: [String] {
        let cuisines = recipes.map { $0.cuisine }
        let uniqueCuisines = Array(Set(cuisines)).sorted()
        return ["All Recipes"] + uniqueCuisines
    }
    
    // helper method that returns recipes based on the selected filter
    func recipes(for filter: String) -> [Recipe] {
        if filter == "All Recipes" {
            return recipes
        } else {
            return recipes.filter { $0.cuisine == filter }
        }
    }
}
