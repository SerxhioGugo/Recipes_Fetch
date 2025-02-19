//
//  NoRecipesView.swift
//  Recipes_Fetch
//
//  Created by Serxhio Gugo on 2/18/25.
//

import SwiftUI

struct NoRecipesFoundView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Image(systemName: "tray")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 50)
                .foregroundColor(.gray)
            
            Text("No Recipes Found at the moment.\nCheck back later.")
                .foregroundColor(.gray)
                .padding(.top, 10)
                .multilineTextAlignment(.center)
            
            Spacer(minLength: 400)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
