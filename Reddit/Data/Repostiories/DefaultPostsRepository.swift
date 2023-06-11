//
//  DefaultInitialPostsRepository.swift
//  Reddit
//
//  Created by Agustin on 09/06/2023.
//

import Foundation

protocol PostsRepository {
    func fetchPostsList(nextPage: String,
                        completion: @escaping(Result<PageInformation, Error>) -> Void) -> Cancellable?
    func searchPosts(query: SearchRequest, completion: @escaping(Result<PageInformation, Error>) -> Void) -> Cancellable?
}

final class DefaultPostsRepository {

    private let dataTransferService: DataTransferService

    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }

}

extension DefaultPostsRepository: PostsRepository {

    func fetchPostsList(nextPage: String, completion: @escaping (Result<PageInformation, Error>) -> Void) -> Cancellable? {
        let task = RepositoryTask()
        let endpoint =  APIEndpoints.getPosts(nextPage: nextPage)

        task.networkTask = self.dataTransferService.request(with: endpoint, completion: { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        })
        return task
    }

    func searchPosts(query: SearchRequest, completion: @escaping (Result<PageInformation, Error>) -> Void) -> Cancellable? {
        let task = RepositoryTask()
        let endpoint =  APIEndpoints.searchPosts(query)

        task.networkTask = self.dataTransferService.request(with: endpoint, completion: { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        })
        return task
    }

}
