//
//  SceneDelegate.swift
//  Snapsea
//
//  Created by Irina Deeva on 09/09/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: MainCoordinator?
    let servicesAssembly = ServicesAssembly(
        networkClient: DefaultNetworkClient(),
        photoStorage: PhotoStorageImpl()
    )

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController()

        coordinator = MainCoordinator(
            servicesAssembly: servicesAssembly,
            navigationController: navigationController
        )
        coordinator?.start()

        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }
}

