////
////  ImageCacheStorage.swift
////  Snapsea
////
////  Created by Irina Deeva on 11/09/24.
////
//
//import Foundation
//
//protocol ImageCacheStorage: AnyObject {
//    func saveImageCache(_ ImageCache: ImageCache)
//    func getImageCache(with id: String) -> ImageCache?
//}
//
//final class ImageCacheStorageImpl: ImageCacheStorage {
//    private var storage: [String: ImageCache] = [:]
//
//    private let syncQueue = DispatchQueue(label: "sync-ImageCache-queue")
//
//    func saveImageCache(_ ImageCache: ImageCache) {
//        syncQueue.async { [weak self] in
//            self?.storage[ImageCache.id] = ImageCache
//        }
//    }
//
//    func getImageCache(with id: String) -> ImageCache? {
//        syncQueue.sync {
//            storage[id]
//        }
//    }
//
//}
