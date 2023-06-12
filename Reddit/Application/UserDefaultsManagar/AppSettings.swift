//
//  AppSettings.swift
//  Reddit
//
//  Created by Agustin on 11/06/2023.
//

import Foundation

struct AppSettings {
    struct General {
        @UserDefaultsManager(valueKey: .completeScreenPermissions, dataStorage: false)
        static var completeScreenPermissions: Bool
    }
}
