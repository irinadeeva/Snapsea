//
//  Coordinator.swift
//  Snapsea
//
//  Created by Irina Deeva on 10/09/24.
//

import Foundation
import UIKit

protocol Coordinator {
    
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}
