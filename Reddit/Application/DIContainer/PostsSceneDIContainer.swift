//
//  PostsSceneDIContainert.swift
//  Reddit
//
//  Created by Agustin on 09/06/2023.
//

import UIKit

protocol PostsListFlowCoordinatorDependencies {
    func makePostsListViewController(actions: PostsListViewModelActions) -> PostListViewController
}


final class PostsSceneDIContainer: PostsListFlowCoordinatorDependencies {
   
    struct Dependencies {
        let apiDataTransferService: DataTransferService
    }

    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makePostsListRepository() -> PostsRepository {
        return DefaultPostsRepository(dataTransferService: dependencies.apiDataTransferService)
    }
    
    func makePostsListUseCase() -> LoadPostUseCase {
        return DefaultLoadPostUseCase(postsRepository: makePostsListRepository())
    }
    
    func makeSearchPostUseCase() -> SearchPostsUseCase {
        return DefaultSearchPostsUseCase(postsRepository: makePostsListRepository())
    }
    
    
    func makePostsListViewModel(actions: PostsListViewModelActions) -> PostsListViewModel {
        return DefaultPostListViewModel(
            loadPostUseCase: makePostsListUseCase(),
            searchPostsUseCase: makeSearchPostUseCase(),
        actions: actions
        )
    }
    
    func makePostsListViewController(actions: PostsListViewModelActions) -> PostListViewController {
        return PostListViewController.create(with: makePostsListViewModel(actions: actions))
    }
    
    // MARK: - Flow Coordinators
    func makePostsListFlowCoordinator(navigationController: UINavigationController) -> HomeFlowCoordinator {
        return HomeFlowCoordinator(navigationController: navigationController,
            dependencies: self)
    }

}
