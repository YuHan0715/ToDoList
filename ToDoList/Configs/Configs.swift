
import Foundation

struct Configs {
    
    struct App {
        
//        static var appVersion: String { // version format
//            let strAppVersion =  Bundle.main.appShortVersion
//            return strAppVersion
//        }
        
        static let basicScreenWidth = 375.0
    }
    
    struct Network {
        static let loggingEnabled = true
        static let useStaging = true   // set true for tests
        static let serverUrl: String = {
            return "https://TodoList/"
        }()
        
        static let EncryptKey: String = ""
    }
    
    enum UserDefaultsKeys: String {
        case example = "example"
    }
}
