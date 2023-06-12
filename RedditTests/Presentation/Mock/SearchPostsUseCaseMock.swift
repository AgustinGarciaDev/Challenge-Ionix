//
//  SearchPostsUseCaseMock.swift
//  RedditTests
//
//  Created by Agustin on 12/06/2023.
//

import Foundation
@testable import Reddit
import XCTest

class LoadPostsUseCaseMock: LoadPostUseCase {
    var expectation: XCTestExpectation?
    var error: Error?
    var page = PageInformation(data: PageData(after: "",
                                                dist: 1, children: [
                                                 PostList(data: PostData(title: "", score: 10, postHint: "image", thumbnail: "", urlOvrridenByDest: "", numberComments: 5, linkFlairText: "Shitposting")),
                                                 PostList(data: PostData(title: "", score: 10, postHint: "video", thumbnail: "", urlOvrridenByDest: "", numberComments: 5, linkFlairText: "Shitposting"))
                                                ],
                                                before: ""))
    
    func execute(nexPage: String, completion: @escaping (Result<Reddit.PageInformation, Error>) -> Void) -> Reddit.Cancellable? {
        if let error = error {
            completion(.failure(error))
        }else {
            completion(.success(page))
        }
        
        expectation?.fulfill()
        return nil
    }
}
