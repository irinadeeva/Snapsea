//
//  PhotoAssembly.swift
//  Snapsea
//
//  Created by Irina Deeva on 11/09/24.
//

import UIKit

final class PhotoAssembly {
    private let servicesAssembly: ServicesAssembly

    init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembly = servicesAssembler
    }

    func build() -> PhotoListViewController {
        let presenter = PhotoListPresenterImpl(
            photoService: servicesAssembly.photoService
        )

        let viewController = PhotoListViewController(presenter: presenter)
        presenter.view = viewController

        return viewController
    }
}
