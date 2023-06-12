//
//  HomeCoordinator.swift
//  Reddit
//
//  Created by Agustin on 09/06/2023.
//

import UIKit

final class HomeFlowCoordinator: Coordinator {
    var navigationController: UINavigationController
    private let dependencies: PostsListFlowCoordinatorDependencies

    init(navigationController: UINavigationController, dependencies: PostsListFlowCoordinatorDependencies ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func start() {
        let actions = PostsListViewModelActions(showPermissions: showPermissions)
        let viewController = dependencies.makePostsListViewController(actions: actions)
        viewController.view.backgroundColor = .white
        navigationController.pushViewController(viewController, animated: false)
    }

    func showPermissions() {
        let permissionsSceneDIContainer = PermissionsSceneDIContainer()
        let flowCoordiantor = permissionsSceneDIContainer.makePermissionsFlowCoordinator(navigationController: navigationController)
        flowCoordiantor.start()
    }
}
