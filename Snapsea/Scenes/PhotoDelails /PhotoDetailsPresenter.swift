//
//  PhotoDetailsPresenter.swift
//  Snapsea
//
//  Created by Irina Deeva on 12/09/24.
//

import Foundation

protocol PhotoDetailsPresenter {
    func viewDidLoad()
    func getCachedImage(for url: String) -> Data?
}

final class PhotoDetailsPresenterImpl: PhotoDetailsPresenter {

    // MARK: - Properties

    weak var view: PhotoDetailsView?
    private let service: PhotoService
    private let id: String
    private var imageCache = NSCache<NSString, NSData>()

    private var state = State<Photo>.initial {
        didSet {
            stateDidChanged()
        }
    }

    init(id: String, photoService: PhotoService) {
        self.id = id
        self.service = photoService
    }

    func viewDidLoad() {
        state = .loading
    }

    func getCachedImage(for url: String) -> Data? {
        return imageCache.object(forKey: url as NSString) as Data?
    }


    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            view?.showLoading()
            loadPhoto()
        case .data(let photo):
            view?.fetchPhoto(photo)
            view?.hideLoading()
        case .failed(let error):
            let errorModel = makeErrorModel(error)
            view?.hideLoading()
            view?.showError(errorModel)
        }
    }

    private func loadPhoto() {
        let photo = service.fetchPhoto(with: id)
        if let photo {
            cachePhotoImages(for: photo)
        }
    }

    private func cachePhotoImages(for photo: Photo) {

        if let imageURL = URL(string: photo.smallImageURL), imageCache.object(forKey: photo.smallImageURL as NSString) == nil {
            DispatchQueue.global().async { [weak self] in
                guard let self else { return }

                if let imageData = try? Data(contentsOf: imageURL) {
                    self.imageCache.setObject(imageData as NSData, forKey: photo.smallImageURL as NSString)
                    self.state = .data(photo)
                }
            }
        }
    }

    private func makeErrorModel(_ error: Error) -> ErrorModel {
        let message: String
        switch error {
        case is NetworkClientError:
            message = "Error.network"
        default:
            message = "Error.unknown"
        }

        let actionText = "Repeat"
        return ErrorModel(message: message, actionText: actionText) { [weak self] in
            self?.state = .loading

        }
    }
}
