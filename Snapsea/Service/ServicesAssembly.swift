//
//  ServicesAssembly.swift
//  Snapsea
//
//  Created by Irina Deeva on 11/09/24.
//

import Foundation

final class ServicesAssembly {

    private let networkClient: NetworkClient
    private let photoStorage: PhotoStorage

    init(networkClient: NetworkClient, photoStorage: PhotoStorage) {
        self.networkClient = networkClient
        self.photoStorage = photoStorage
    }

    var photoService: PhotoService {
        PhotoServiceImpl(
            networkClient: networkClient,
            storage: photoStorage
        )
    }
}
