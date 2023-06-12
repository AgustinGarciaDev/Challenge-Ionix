//
//  APIEndpoint.swift
//  Reddit
//
//  Created by Agustin on 09/06/2023.
//

import Foundation

struct APIEndpoints {
    static func getPosts(nextPage: String) -> Endpoint <PageInformation> {
        return Endpoint(path: "r/memes/new/.json",
                        method: .get,
                        queryParameters: [
                            "limit": "100",
                            "after": nextPage
                        ]
        )
    }

    static func searchPosts(_ request: SearchRequest) -> Endpoint <PageInformation> {
        return Endpoint(path: "r/memes/search.json",
                        method: .get,
                        queryParameters: [
                            "q": request.search,
                            "limit": "100"
                        ]
        )
    }
}
