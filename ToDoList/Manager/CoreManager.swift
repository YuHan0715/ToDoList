
import Foundation

class CoreManager {
    
    static let shared = CoreManager()
    
}

extension CoreManager {
    
    class func save(value: Any, key: String, completion: (() -> Void)? = nil) {
        
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
        
        completion?()
    }
    
    class func save(value: Any, key: Configs.UserDefaultsKeys, completion: (() -> Void)? = nil) {
        CoreManager.save(value: value, key: key.rawValue, completion: completion)
    }
    
    // - Parameter key: String
    class func getValue(key: String) -> Any {
        return UserDefaults.standard.value(forKey: key) ?? ""
    }

    class func getIntValue(key: String) -> Int? {
        return CoreManager.getValue(key: key) as? Int
    }
    
    // - Parameter key: Configs.UserDefaultsKeys
    class func getCoreValue(key: Configs.UserDefaultsKeys) -> Any {
        return UserDefaults.standard.value(forKey: key.rawValue) ?? ""
    }
    
    class func getCoreString(key: Configs.UserDefaultsKeys) -> String {
        return UserDefaults.standard.string(forKey: key.rawValue) ?? ""
    }
    
    class func getCoreInt(key: Configs.UserDefaultsKeys) -> Int? {
        return CoreManager.getCoreValue(key: key) as? Int
    }
    
    class func getCoreBool(key: Configs.UserDefaultsKeys) -> Bool? {
        return UserDefaults.standard.value(forKey: key.rawValue) as? Bool
    }
    
    class func getCoreDate(key: Configs.UserDefaultsKeys) -> Date? {
        return UserDefaults.standard.value(forKey: key.rawValue) as? Date
    }
}
