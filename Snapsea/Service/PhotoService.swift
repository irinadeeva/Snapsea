//
//  ImagesListService.swift
//  Snapsea
//
//  Created by Irina Deeva on 11/09/24.
//

import Foundation

typealias PhotoCompletion = (Result<[Photo], Error>) -> Void

protocol PhotoService {
    func loadPhoto(for text: String, for page: Int, completion: @escaping PhotoCompletion)
    func fetchPhoto(with id: String) -> Photo?
}

final class PhotoServiceImpl: PhotoService {
    private let networkClient: NetworkClient
    private let storage: PhotoStorage
    private static let dateFormatterISO8601 = ISO8601DateFormatter()

    init(networkClient: NetworkClient, storage: PhotoStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }

    func loadPhoto(for text: String, for page: Int, completion: @escaping PhotoCompletion) {
        let request = PhotoRequest(text: text, page: page)

        networkClient.send(request: request, type: SearchedPhotoResultResponse.self) { [weak self] result in
            switch result {
            case .success(let data):

                let validPhotos: [Photo] = data.results.compactMap { photoResponse in
                    if let validPhoto = self?.isValidPhoto(photoResponse) {
                        self?.storage.savePhoto(validPhoto)
                        return validPhoto
                    }
                    return nil
                }

                completion(.success(validPhotos))
            case .failure(let error):
                completion(.failure(error))
            }
        }

    }

    func fetchPhoto(with id: String) -> Photo? {
        return storage.getPhoto(with: id)
    }

    private func isValidPhoto(_ photo: PhotoResultResponse) -> Photo? {
        guard let description = photo.description,
              let author = photo.user.name,
              let small = photo.urls.small,
              let thumb = photo.urls.thumb,
              let createdAtString = photo.createdAt else {
            return nil
        }

        guard let createdAt = Self.dateFormatterISO8601.date(from: createdAtString) else {
            return nil
        }

        let data =  DateFormatter.russianDateFormatter.string(from: createdAt)

        return Photo(id: photo.id,
                     smallImageURL: small.absoluteString,
                     thumbImageURL: thumb.absoluteString,
                     description: description,
                     author: author,
                     createdDate: data)
    }
}
