//
//  ImageService.swift
//  Recipes_Fetch
//
//  Created by Serxhio Gugo on 2/18/25.
//

import Foundation
import UIKit
import CryptoKit

enum ImageCacheError: Error {
    case failedToCreateCacheDirectory(Error)
    case diskReadFailed(Error)
    case diskWriteFailed(Error)
    case downloadFailed(Error)
    case decodeFailed
}

actor ImageService {
    static let shared = ImageService()
    private let cacheDirectory: URL
    private let memoryCache = NSCache<NSString, UIImage>()

    init() {
        let fileManager = FileManager.default
        let paths = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        self.cacheDirectory = paths[0].appendingPathComponent("ImageCache", isDirectory: true)
        do {
            try fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        } catch {
            print("Error: Failed to create cache directory: \(error)")
        }
    }
    
    func image(for url: URL) async throws -> UIImage {
        let key = cacheKey(for: url) as NSString
        
        // return the image from memory cache if available
        if let cachedImage = memoryCache.object(forKey: key) {
            return cachedImage
        }
        
        let fileURL = fileURL(for: url)
        let data: Data
        
        // load data from disk if that fails, download and then save it
        do {
            data = try await loadCachedData(from: fileURL)
        } catch {
            data = try await downloadData(from: url)
            try await saveData(data, to: fileURL)
        }
        
        let image = try await decodeImage(from: data)
        memoryCache.setObject(image, forKey: key)
        return image
    }
    
    // create a unique cache key from the URL.
    private func cacheKey(for url: URL) -> String {
        SHA256.hash(data: Data(url.absoluteString.utf8))
            .map { String(format: "%02x", $0) }
            .joined()
    }
        
    private func fileURL(for url: URL) -> URL {
        let hash = cacheKey(for: url)
        return cacheDirectory.appendingPathComponent(hash)
    }
    
    // load cached data from disk
    private func loadCachedData(from fileURL: URL) async throws -> Data {
        try await Task.detached(priority: .userInitiated) {
            do {
                return try Data(contentsOf: fileURL)
            } catch {
                throw ImageCacheError.diskReadFailed(error)
            }
        }.value
    }
    
    // download data that will be converted to UIImage
    private func downloadData(from url: URL) async throws -> Data {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        } catch {
            throw ImageCacheError.downloadFailed(error)
        }
    }
    
    // saves data to disk
    private func saveData(_ data: Data, to fileURL: URL) async throws {
        try await Task.detached(priority: .utility) {
            do {
                try data.write(to: fileURL)
            } catch {
                throw ImageCacheError.diskWriteFailed(error)
            }
        }.value
    }
    
    // decodes image from data
    private func decodeImage(from data: Data) async throws -> UIImage {
        try await Task.detached(priority: .userInitiated) {
            guard let image = UIImage(data: data) else {
                throw ImageCacheError.decodeFailed
            }
            return image
        }.value
    }
}
