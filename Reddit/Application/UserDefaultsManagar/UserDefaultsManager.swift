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
            switch newValue {
            case let value as Optional<Any>:
                if let unwrappedValue = value {
                    userDefaults.set(unwrappedValue, forKey: keyValue.rawValue)
                } else {
                    userDefaults.removeObject(forKey: keyValue.rawValue)
                }
            default:
                userDefaults.set(newValue, forKey: keyValue.rawValue)
            }
        }
    }
}

