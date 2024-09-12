//
//  ImagesStorage.swift
//  Snapsea
//
//  Created by Irina Deeva on 11/09/24.
//

import Foundation

protocol PhotoStorage: AnyObject {
    func savePhoto(_ photo: Photo)
    func getPhoto(with id: String) -> Photo?
}

final class PhotoStorageImpl: PhotoStorage {
    private var storage: [String: Photo] = [:]

    private let syncQueue = DispatchQueue(label: "sync-photo-queue")

    func savePhoto(_ photo: Photo) {
        syncQueue.async { [weak self] in
            self?.storage[photo.id] = photo
        }
    }

    func getPhoto(with id: String) -> Photo? {
        syncQueue.sync {
            storage[id]
        }
    }
}
