//
//  PostListViewModelTests.swift
//  RedditTests
//
//  Created by Agustin on 12/06/2023.
//

import XCTest
@testable import Reddit

final class PostListViewModelTests: XCTestCase {
    
    var loadPostUseCase: LoadPostsUseCaseMock!
    var searchPostUseCase: SearchPostsUseCaseMock!
    var viewModel: DefaultPostListViewModel!
    
    override func setUp() {
        super.setUp()
        loadPostUseCase = LoadPostsUseCaseMock()
        searchPostUseCase = SearchPostsUseCaseMock()
        viewModel = DefaultPostListViewModel(loadPostUseCase: loadPostUseCase, searchPostsUseCase: searchPostUseCase)
    }
    
    let postResult: [PageInformation] = [
        PageInformation(data: PageData(after: nil,
                                       dist: 1, children: [
                                        PostList(data: PostData(title: "", score: 10, postHint: "video", thumbnail: "", urlOvrridenByDest: "", numberComments: 5, linkFlairText: "Shitposting")),
                                        PostList(data: PostData(title: "", score: 10, postHint: "video", thumbnail: "", urlOvrridenByDest: "", numberComments: 5, linkFlairText: "Arte"))
                                       ],
                                       before: nil)),
        PageInformation(data: PageData(after: nil,
                                       dist: 1, children: [
                                        PostList(data: PostData(title: "Condorito", score: 10, postHint: "image", thumbnail: "", urlOvrridenByDest: "", numberComments: 5, linkFlairText: "Shitposting"))
                                       ],
                                       before: nil)),
        PageInformation(data: PageData(after: nil,
                                       dist: 1, children: [
                                       ],
                                       before: nil))
    ]
    
    private enum SearchCharactersUseCaseError: Error {
        case someError
    }
    
    func test_whenLoadPostsUseCaseRetrievesFirstPage_thenViewModelContaintsOnlyResult() {
        //GIVEN
        loadPostUseCase.expectation = self.expectation(description:"Contains only first page")
        let sut = viewModel
        
        //When
        sut?.didLoadPosts()
        
        //THEN
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(sut?.items.value.count , 1)
    }
    
    func test_whenLoadPostsUseCaseRetrievesFirstPage_thenViewModelContaintsError() {
        //GIVEN
        loadPostUseCase.expectation = self.expectation(description:"Contains error")
        loadPostUseCase.error = SearchCharactersUseCaseError.someError
        let sut = viewModel
        
        //WHEN
        sut?.didLoadPosts()
        
        //THEN
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(sut?.error)
    }
    
    func test_whenLoadPostsUseCaseRetrievesFirstPage_thenViewModelFilterAndNotPosts() {
        //GIVEN
        loadPostUseCase.expectation = self.expectation(description:"Not contains posts")
        loadPostUseCase.page = postResult[0]
        let sut = viewModel
        
        //WHEN
        sut?.didLoadPosts()
        
        //THEN
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(sut?.items.value.count , 0)
    }
    
    func test_whenSearchPostsUseCaseRetrievesFirstPage_thenViewModelContaintsOnlyResult() {
        //GIVEN
        searchPostUseCase.expectation = self.expectation(description:"Contains only first page")
        searchPostUseCase.page = postResult[1]
        let sut = viewModel
        
        //WHEN
        sut?.didSearch(query: "Condorito")
        
        //THEN
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(sut?.items.value.count , 1)
    }
    
    func test_whenSearchPostsUseCaseRetrievesFirstPage_thenViewModelNotContaintsResults() {
        //GIVEN
        searchPostUseCase.expectation = self.expectation(description: "Not contains posts")
        let sut = viewModel
        searchPostUseCase.page = postResult[2]
        
        //WHEN
        sut?.didSearch(query: "example")
        
        //THEN
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(sut?.items.value.count , 0)
    }
}
