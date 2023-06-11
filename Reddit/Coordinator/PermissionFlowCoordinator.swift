//
//  ViewFlowCoordinator.swift
//  Reddit
//
//  Created by Agustin on 08/06/2023.
//

import UIKit

final class PermissionsFlowCoordinator: Coordinator {

    var navigationController: UINavigationController
    private let dependencies: PermissionsFlowCoordinatorDependencies
    private let appDIContainer: AppDIContainer
    
    private var pages: [Pages] = Pages.allCases
    private var currentIndex: Int = 0
    
    init(navigationController: UINavigationController, dependencies: PermissionsFlowCoordinatorDependencies, appDIContainer: AppDIContainer = AppDIContainer()) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        self.appDIContainer = appDIContainer
    }
    
    func start() {
        screenPermissionRequest(index: currentIndex)
    }
    
    private func screenPermissionRequest(index: Int) {
        let viewController = dependencies.makePermissionsViewController(page: pages[index])
        viewController.delegate = self
        viewController.view.backgroundColor = .white
        navigationController.pushViewController(viewController, animated: false)
    }
    
    private func homeCoordinator()  {
        saveSeedPermissions()
        let postListSceneDIContainer = appDIContainer.makePostsSceneDIContainer()
        let flow = postListSceneDIContainer.makePostsListFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
    
    private func  saveSeedPermissions() {
        var seed = AppSettings.General.completeScreenPermissions
        if !seed {
            AppSettings.General.completeScreenPermissions = true
        }
    }
}


extension PermissionsFlowCoordinator: DelegatePermissionsRequest {
    func nextView(with indexPage: Int) {
        var index = indexPage
        if index >= self.pages.count - 1 {
            homeCoordinator()
            return
        }
        index += 1
        screenPermissionRequest(index: index)
    }
}
