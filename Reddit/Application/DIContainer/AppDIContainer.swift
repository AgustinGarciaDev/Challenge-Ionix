//
//  AppDIContainer.swift
//  Reddit
//
//  Created by Agustin on 09/06/2023.
//

import Foundation

final class AppDIContainer {

    lazy var appConfiguration = AppConfiguration()

    // MARK: - Network
    lazy var apiDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(baseURL: URL(string: appConfiguration.apiBaseURL)!,
                                          queryParameters: [:])

        let apiDataNetwork = DefaultNetworkService(config: config)
        return DefaultDataTransferService(with: apiDataNetwork)
    }()

    func makePostsSceneDIContainer() -> PostsSceneDIContainer {
        let dependencies = PostsSceneDIContainer.Dependencies(apiDataTransferService: apiDataTransferService)
        return PostsSceneDIContainer(dependencies: dependencies)
    }

    func makePermissionSceneDIContainer() -> PermissionsSceneDIContainer {
        return PermissionsSceneDIContainer()
    }
}
