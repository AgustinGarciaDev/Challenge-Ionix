//
//  UserDefaultsManager.swift
//  Reddit
//
//  Created by Agustin on 11/06/2023.
//

import Foundation

@propertyWrapper
struct UserDefaultsManager<T> {
    private let keyValue: UserDefultsKeys
    private let valueData: T
    private let userDefaults: UserDefaults = .standard
    
    init(valueKey: UserDefultsKeys, dataStorage: T) {
        keyValue = valueKey
        valueData = dataStorage
    }
    
    var wrappedValue: T {
        get { userDefaults.value(forKey: keyValue.rawValue) as? T ?? valueData }
        set {
            switch (newValue as Any) {
            case Optional<Any>.some(let value):
                userDefaults.set(value, forKey: keyValue.rawValue)
            case Optional<Any>.none:
                userDefaults.removeObject(forKey: keyValue.rawValue)
            default:
                userDefaults.set(newValue, forKey: keyValue.rawValue)
            }
        }
    }
}
