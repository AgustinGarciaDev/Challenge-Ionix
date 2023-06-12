//
//  PostModel.swift
//  Reddit
//
//  Created by Agustin on 09/06/2023.
//

import Foundation

// MARK: - PageInformation
struct PageInformation: Codable, Equatable {
    let data: PageData
}

// MARK: - PageData
struct PageData: Codable, Equatable {
    let after: String?
    let dist: Int?
    let children: [PostList]
    let before: String?
}

// MARK: - PostList
struct PostList: Codable, Equatable {
    let data: PostData?
}

// MARK: - PostData
struct PostData: Codable, Equatable {
    let title: String?
    let score: Int?
    let postHint: String?
    let thumbnail: String?
    let urlOvrridenByDest: String?
    let numberComments: Int?
    let linkFlairText: String?

    enum CodingKeys: String, CodingKey {
        case title, score
        case postHint = "post_hint"
        case thumbnail
        case urlOvrridenByDest = "url_overridden_by_dest"
        case numberComments = "num_comments"
        case linkFlairText = "link_flair_text"
    }
}
