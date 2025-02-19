//
//  RecipeCardView.swift
//  Recipes_Fetch
//
//  Created by Serxhio Gugo on 2/18/25.
//

import SwiftUI

struct RecipeCardView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isExpanded = false
    @State private var showFullScreenImage = false
    
    let recipe: Recipe
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    showFullScreenImage = true
                }) {
                    CachedAsyncImage(
                        url: URL(string: recipe.photoURLSmall),
                        placeholder: AnyView(ProgressView()),
                        contentMode: .fit
                    )
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(
                        Image(systemName: "arrow.up.left.and.arrow.down.right")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 12, height: 12)
                            .padding(4)
                            .background(Color.black.opacity(0.4))
                            .clipShape(Circle())
                            .foregroundColor(.white)
                            .padding(4),
                        alignment: .bottomTrailing
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                VStack(alignment: .leading) {
                    Text(recipe.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(recipe.cuisine)
                        .font(.system(size: 12))
                        .bold()
                        .foregroundColor(.white)
                        .padding(4)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.orange.opacity(0.5))
                        )
                }
                Spacer()
                Button {
                    withAnimation {
                        isExpanded.toggle()
                    }
                } label: {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .imageScale(.large)
                        .foregroundColor(.primary)
                        .padding(16)
                        .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(10)
            
            if isExpanded {
                HStack {
                    if let youtubeURLString = recipe.youtubeURL,
                       !youtubeURLString.isEmpty,
                       let youtubeURL = URL(string: youtubeURLString) {
                        Link(destination: youtubeURL) {
                            HStack {
                                Image(systemName: "play.rectangle.fill")
                                Text("Watch on YouTube")
                            }
                            .font(.system(size: 12))
                            .foregroundColor(.red)
                            .padding(5)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                    if let sourceURLString = recipe.sourceURL,
                       !sourceURLString.isEmpty,
                       let sourceURL = URL(string: sourceURLString) {
                        Link(destination: sourceURL) {
                            HStack {
                                Image(systemName: "link")
                                Text("Full Recipe")
                            }
                            .font(.system(size: 12))
                            .foregroundColor(.green)
                            .padding(5)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                }
                .padding(.bottom, 4)
            }
        }
        .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(UIColor.systemBackground))
                        .shadow(
                            color: colorScheme == .dark
                                ? Color.white.opacity(0.6)
                                : Color.black.opacity(0.2),
                            radius: 3, x: 0, y: 2
                        )
                )
        .padding(.horizontal)
        .fullScreenCover(isPresented: $showFullScreenImage) {
            FullScreenRecipeImageView(recipe: recipe, isPresented: $showFullScreenImage)
        }
    }
}
