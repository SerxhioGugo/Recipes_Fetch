//
//  ContentView.swift
//  Recipes_Fetch
//
//  Created by Serxhio Gugo on 2/17/25.
//

import SwiftUI

struct MainRecipeView: View {
    @StateObject var viewModel = RecipeViewModel()
    @State private var selectedFilter: String = "All Recipes"
    
    var body: some View {
        NavigationStack {
            VStack {
                FilterRecipesHorizontalRowView(viewModel: viewModel, selectedFilter: $selectedFilter)
                    .padding(.bottom, 10)
                
                if viewModel.isLoading {
                    LoadingView()
                } else if viewModel.recipes.isEmpty {
                    NoRecipesFoundView()
                } else {
                    RecipeListView(recipes: viewModel.recipes(for: selectedFilter))
                }
            }
            .navigationTitle("Recipes")
            .animation(.easeInOut, value: selectedFilter)
        }
        .onAppear {
            viewModel.fetchRecipes()
        }
        .refreshable {
            // this is not necessary as we want the reload to happen as quickly as possible but simply provides a better visual
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            viewModel.fetchRecipes()
        }
    }
}

#Preview {
    MainRecipeView()
}
