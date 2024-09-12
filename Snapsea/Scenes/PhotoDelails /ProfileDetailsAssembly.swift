//
//  ProfileDetailsAssembly.swift
//  Snapsea
//
//  Created by Irina Deeva on 12/09/24.
//

import Foundation

import UIKit

final class PhotoDetailsAssembly {
    private let id: String
    private let servicesAssembly: ServicesAssembly

    init(id: String, servicesAssembler: ServicesAssembly) {
        self.id = id
        self.servicesAssembly = servicesAssembler
    }

    func build() -> PhotoDetailsViewController {
        let presenter = PhotoDetailsPresenterImpl(
            id: id,
            photoService: servicesAssembly.photoService
        )

        let viewController = PhotoDetailsViewController(presenter: presenter)
        presenter.view = viewController

        return viewController
    }
}
