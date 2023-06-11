//
//  CoordinatorProtocol.swift
//  Reddit
//
//  Created by Agustin on 08/06/2023.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController {get set}
    func start()
}
