//
//  ImageListPresenter.swift
//  Snapsea
//
//  Created by Irina Deeva on 11/09/24.
//

import Foundation

protocol PhotoListPresenter {
    func findPhotosFor(_ text: String)
}

enum PhotoState {
    case initial, loading, failed(Error), data([Photo])
}

final class PhotoListPresenterImpl: PhotoListPresenter {

    // MARK: - Properties

    weak var view: PhotoListView?
    private let service: PhotoService
    private var searchText = ""
    private var state = PhotoState.initial {
        didSet {
            stateDidChanged()
        }
    }

    init(photoService: PhotoService) {
        self.service = photoService
    }

    func findPhotosFor(_ text: String) {
        searchText = text
        state = .loading
    }

    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            view?.showLoading()
            loadPhoto()
        case .data(let photos):
            view?.fetchPhotos(photos)
            view?.hideLoading()
        case .failed(let error):
            let errorModel = makeErrorModel(error)
            view?.hideLoading()
            view?.showError(errorModel)
        }
    }

    private func loadPhoto() {
        var loadedPhotos: [Photo] = []

        //TODO: add dispatch

        service.loadPhoto(for: searchText) { [weak self] result in
                switch result {
                case .success(let photos):
                    loadedPhotos = photos
                    self?.state = .data(loadedPhotos)
                case .failure(let error):
                    self?.state = .failed(error)
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

        let actionText = "Error.repeat"
        return ErrorModel(message: message, actionText: actionText) { [weak self] in
            self?.state = .loading
        }
    }
}
