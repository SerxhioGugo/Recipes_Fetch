//
//  FilterRecipesHorizontalRowView.swift
//  Recipes_Fetch
//
//  Created by Serxhio Gugo on 2/18/25.
//

import SwiftUI

struct FilterRecipesHorizontalRowView: View {
    @ObservedObject var viewModel: RecipeViewModel
    @Binding var selectedFilter: String
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(viewModel.cuisineFilters, id: \.self) { filter in
                    Button(action: {
                        withAnimation {
                            selectedFilter = filter
                        }
                    }) {
                        Text(filter)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(Color.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(
                                selectedFilter == filter
                                ? Color.orange.opacity(0.7)
                                : Color.gray.opacity(0.6)
                            )
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}
