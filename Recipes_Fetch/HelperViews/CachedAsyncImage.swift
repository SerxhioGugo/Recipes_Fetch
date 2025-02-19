//
//  CachedAsyncImage.swift
//  Recipes_Fetch
//
//  Created by Serxhio Gugo on 2/18/25.
//

import SwiftUI

struct CachedAsyncImage: View {
    
    let url: URL?
    var placeholder: AnyView = AnyView(ProgressView())
    var contentMode: ContentMode = .fill
    
    @State private var image: UIImage?
    @State private var hasStartedLoading = false
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            } else {
                placeholder
                    .onAppear {
                        if !hasStartedLoading {
                            hasStartedLoading = true
                            Task {
                                await loadImage()
                            }
                        }
                    }
            }
        }
    }
    
    private func loadImage() async {
        guard let url = url else {
            self.image = UIImage(systemName: "photo")
            return
        }
        
        do {
            let loadedImage = try await ImageService.shared.image(for: url)
            await MainActor.run {
                image = loadedImage
            }
        } catch {
            print("Error loading image: \(error)")
            self.image = UIImage(systemName: "photo")
        }
    }
}
