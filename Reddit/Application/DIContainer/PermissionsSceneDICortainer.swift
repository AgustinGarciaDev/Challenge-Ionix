//
//  NotificationSceneDICortainer.swift
//  Reddit
//
//  Created by Agustin on 10/06/2023.
//

import UIKit

protocol PermissionsFlowCoordinatorDependencies {
    func makePermissionsViewController(page: Pages) -> PermissionsRequestViewController
}

final class PermissionsSceneDIContainer: PermissionsFlowCoordinatorDependencies {

    func makePermissionsViewController(page: Pages) -> PermissionsRequestViewController {
        return PermissionsRequestViewController(with: page)
    }

    // MARK: - Flow Coordinators
    func makePermissionsFlowCoordinator(navigationController: UINavigationController) -> PermissionsFlowCoordinator {
        return PermissionsFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}
