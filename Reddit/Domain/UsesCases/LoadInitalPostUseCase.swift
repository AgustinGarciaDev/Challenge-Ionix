//
//  LoadInitalPostUseCase.swift
//  Reddit
//
//  Created by Agustin on 09/06/2023.
//

import Foundation

protocol LoadPostUseCase {
    func execute(nexPage: String,
                 completion: @escaping (Result<PageInformation, Error>) -> Void) -> Cancellable?
}

final class DefaultLoadPostUseCase: LoadPostUseCase {

    private let postsRepository: PostsRepository

    init(postsRepository: PostsRepository) {
        self.postsRepository = postsRepository
    }

    func execute(nexPage: String, completion: @escaping (Result<PageInformation, Error>) -> Void) -> Cancellable? {
        return postsRepository.fetchPostsList(nextPage: nexPage) { result in
            completion(result)
         }
    }
}
