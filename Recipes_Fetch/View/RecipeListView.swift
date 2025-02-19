//
//  RecipeListView.swift
//  Recipes_Fetch
//
//  Created by Serxhio Gugo on 2/18/25.
//

import SwiftUI

struct RecipeListView: View {
    let recipes: [Recipe]
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(recipes) { recipe in
                    RecipeCardView(recipe: recipe)
                }
            }
            .padding(.horizontal)
            .padding(.top, 10)
        }
    }
}
