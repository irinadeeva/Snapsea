//
//  ImagesListService.swift
//  Snapsea
//
//  Created by Irina Deeva on 11/09/24.
//

import Foundation

typealias PhotoCompletion = (Result<[Photo], Error>) -> Void

protocol PhotoService {
    func loadPhoto(for text: String, completion: @escaping PhotoCompletion)
    func fetchPhoto(with id: String) -> Photo?
}

final class PhotoServiceImpl: PhotoService {

    private let networkClient: NetworkClient
    private let storage: PhotoStorage
    private var lastLoadedPage: Int = 0

    init(networkClient: NetworkClient, storage: PhotoStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }

    func loadPhoto(for text: String, completion: @escaping PhotoCompletion) {

        let request = PhotoRequest(text: text, page: lastLoadedPage)
        networkClient.send(request: request, type: SearchedPhotoResultResponse.self) { [weak storage] result in
            switch result {
            case .success(let data):
                let photos: [Photo] = data.results.map { photoResponse in
                    let photo = Photo(from: photoResponse)
                    storage?.savePhoto(photo)
                    return photo
                }

                completion(.success(photos))
            case .failure(let error):
                completion(.failure(error))
            }
        }

        lastLoadedPage += 1
    }

    func fetchPhoto(with id: String) -> Photo? {
        return storage.getPhoto(with: id)
    }
}
