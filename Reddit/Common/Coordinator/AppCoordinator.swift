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
        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        homeFlowCoorinator(navigationController)
        //permissionFlowCoordinator(navigationController)
    }
    
    private func permissionsFlowCoordinator(_ navigationController: UINavigationController) {
        let permissionsSceneDIContainer = appDIContainer.makePermissionSceneDIContainer()
        let flow = permissionsSceneDIContainer.makePermissionsFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
    
    private func homeFlowCoorinator(_ navigationController: UINavigationController) {
        let postListSceneDIContainer = appDIContainer.makePostsSceneDIContainer()
        let flow = postListSceneDIContainer.makePostsListFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
}
