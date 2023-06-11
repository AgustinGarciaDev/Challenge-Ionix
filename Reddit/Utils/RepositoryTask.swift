//
//  RepositoryTask.swift
//  Reddit
//
//  Created by Agustinch on 06/02/2023.
//

import Foundation

class RepositoryTask: Cancellable {
    var networkTask: NetworkCancellable?
    var isCancelled: Bool = false

    func cancel() {
        networkTask?.cancel()
        isCancelled = true
    }
}
