//
//  AppCoordinator.swift
//  Reddit
//
//  Created by Agustin on 08/06/2023.
//

import UIKit

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    private let window: UIWindow
    private let appDIContainer: AppDIContainer

    init(navigationController: UINavigationController, window: UIWindow, appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.window = window
        self.appDIContainer = appDIContainer
    }

    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        getSeedStatusPermissions()
    }

    private func permissionsFlowCoordinator(_ navigationController: UINavigationController) {
        let permissionsSceneDIContainer = PermissionsSceneDIContainer()
        let flowCoordiantor = permissionsSceneDIContainer.makePermissionsFlowCoordinator(navigationController: navigationController)
        flowCoordiantor.start()
    }

    private func homeFlowCoorinator(_ navigationController: UINavigationController) {
        let postListSceneDIContainer = appDIContainer.makePostsSceneDIContainer()
        let flow = postListSceneDIContainer.makePostsListFlowCoordinator(navigationController: navigationController)
        flow.start()
    }

    func getSeedStatusPermissions() {
        let seed = AppSettings.General.completeScreenPermissions

        if seed {
            homeFlowCoorinator(navigationController)
        } else {
            permissionsFlowCoordinator(navigationController)
        }
    }
}
