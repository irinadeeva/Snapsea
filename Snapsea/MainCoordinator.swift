//
//  MianCoordinator.swift
//  Snapsea
//
//  Created by Irina Deeva on 10/09/24.
//

import Foundation
import UIKit

final class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = ViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }

    func showDetails() {
        let vc = ImageDetails()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
}
