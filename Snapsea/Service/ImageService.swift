////
////  ImageService.swift
////  Snapsea
////
////  Created by Irina Deeva on 11/09/24.
////
//
//import Foundation
//
//typealias ImageCompletion = (Result<[Image], Error>) -> Void
//
//protocol ImageService {
//    func loadImage(for text: String, completion: @escaping ImageCompletion)
//}
//
//final class ImageServiceImpl: ImageService {
//
//    private let networkClient: NetworkClient
//    private let storage: ImageStorage
//
//    init(networkClient: NetworkClient, storage: ImageStorage) {
//        self.storage = storage
//        self.networkClient = networkClient
//    }
//
//    func loadImage(for text: String, completion: @escaping ImageCompletion) {
////        if let Image = storage.getImage(with: ) {
////            completion(.success(Image))
////            return
////        }
//
//        let request = ImageRequest(text: text)
//        networkClient.send(request: request, type: SearchedImageResultResponse.self) { [weak storage] result in
//            switch result {
//            case .success(let data):
////                storage?.saveImage(data.results)
//                let Images: [Image] = data.results.map { ImageResponse in
//                    let Image = Image(from: ImageResponse)
//                    return Image
//                }
//
//                completion(.success(Images))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
//}
