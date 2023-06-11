//
//  SearchPostsUseCase.swift
//  Reddit
//
//  Created by Agustin on 10/06/2023.
//

import Foundation

protocol SearchPostsUseCase {
    func execute(
        requestValue: SearchRequest,
        completion: @escaping (Result<PageInformation, Error>) -> Void
    ) -> Cancellable?
}

final class DefaultSearchPostsUseCase: SearchPostsUseCase {

    private let postsRepository: PostsRepository

    init(postsRepository: PostsRepository) {
        self.postsRepository = postsRepository
    }

    func execute(
        requestValue: SearchRequest,
        completion: @escaping (Result<PageInformation, Error>) -> Void
    ) -> Cancellable? {

        return postsRepository.searchPosts(query: requestValue) { result in
            completion(result)
        }
    }
}
