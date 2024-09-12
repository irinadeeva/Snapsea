//
//  MianCoordinator.swift
//  Snapsea
//
//  Created by Irina Deeva on 10/09/24.
//

import Foundation
import UIKit

final class MainCoordinator: Coordinator {
    
    var servicesAssembly: ServicesAssembly
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(servicesAssembly: ServicesAssembly, navigationController: UINavigationController) {
        self.servicesAssembly = servicesAssembly
        self.navigationController = navigationController
    }

    func start() {
        let photoAssembly = PhotoAssembly(servicesAssembler: servicesAssembly)
        let vc = photoAssembly.build()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }

    func showDetails(of id: String) {
        let photoDetailsAssembly = PhotoDetailsAssembly(id: id, servicesAssembler: servicesAssembly)
        let vc = photoDetailsAssembly.build()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }

    func goBack() {
        navigationController.popViewController(animated: true)
    }
}
