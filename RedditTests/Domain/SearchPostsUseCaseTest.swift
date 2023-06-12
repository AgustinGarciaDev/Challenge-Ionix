//
//  SearchPostsUseCaseTest.swift
//  RedditTests
//
//  Created by Agustin on 12/06/2023.
//

import XCTest
@testable import Reddit

final class SearchPostsUseCaseTest: XCTestCase {
    
    let postResult: [PageInformation] = [
        PageInformation(data: PageData(after: "",
                                       dist: 1, children: [
                                        PostList(data: PostData(title: "", score: 10, postHint: "", thumbnail: "", urlOvrridenByDest: "", numberComments: 5, linkFlairText: ""))
                                       ],
                                       before: ""))
    ]
    
    enum PostsRepositorySuccessTestError: Error {
        case failedFetching
    }
    
    struct CharactersRepositoryMock: PostsRepository {
        var result: Result<PageInformation, Error>
        
        func fetchPostsList(nextPage: String, completion: @escaping (Result<Reddit.PageInformation, Error>) -> Void) -> Reddit.Cancellable? {
            completion(result)
            return nil
        }
        
        func searchPosts(query: Reddit.SearchRequest, completion: @escaping (Result<Reddit.PageInformation, Error>) -> Void) -> Reddit.Cancellable? {
            completion(result)
            return nil
        }
    }
    
    func testSearchPosts_whenSuccessfullyFetchesPostsInitApp() {
        //GIVEN
        let expectation = XCTestExpectation(description: "Wait for data to complete")
        let repository = CharactersRepositoryMock(result: .success(postResult[0]))
        let sut = DefaultSearchPostsUseCase(postsRepository: repository)
        let search = SearchRequest(search: "")
        
        //WHEN
        _ = sut.execute(requestValue: search, completion: { result in
            switch result {
            case .success(_):
                expectation.fulfill()
            case .failure(_):
                XCTFail("Not supos")
            }
        })
        
        //THEN
        wait(for:[expectation], timeout: 3.0)
    }
    
    func testSearchPosts_whenFailedfullyFetchesPostsInitApp() {
        //GIVEN
        let expectation = XCTestExpectation(description: "Wait for data to complete")
        let repository = CharactersRepositoryMock(result: .failure(PostsRepositorySuccessTestError.failedFetching))
        let sut = DefaultSearchPostsUseCase(postsRepository: repository)
        let search = SearchRequest(search: "")
        
        //WHEN
        _ = sut.execute(requestValue: search, completion: { result in
            switch result {
            case .success(_):
                XCTFail("Not supos")
            case .failure(_):
                expectation.fulfill()
            }
        })
        
        //THEN
        wait(for:[expectation], timeout: 3.0)
    }
}


