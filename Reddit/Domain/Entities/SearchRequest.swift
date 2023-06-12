//
//  SearchRequest.swift
//  Reddit
//
//  Created by Agustin on 10/06/2023.
//

import Foundation

struct SearchRequest: Encodable {
    let limit: String = "100"
    let search: String
}
