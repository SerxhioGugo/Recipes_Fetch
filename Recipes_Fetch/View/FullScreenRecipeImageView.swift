//
//  FullScreenRecipeImageView.swift
//  Recipes_Fetch
//
//  Created by Serxhio Gugo on 2/18/25.
//

import SwiftUI

struct FullScreenRecipeImageView: View {
    let recipe: Recipe
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black.ignoresSafeArea()
                        
            CachedAsyncImage(
                url: URL(string: recipe.photoURLLarge),
                placeholder: AnyView(ProgressView()),
                contentMode: .fit
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
            ZStack {
                Text(recipe.name)
                    .foregroundStyle(Color.white)
                    .fontWeight(.bold)
                HStack {
                    Spacer()
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white.opacity(0.3))
                            .padding()
                    }
                }
            }
        }
    }
}
