
import Foundation

enum LanguageType: String {
    case chinese = "zh-Hant"
    
    var name: String {
        switch self {
        case .chinese:
            return "中文"
        }
    }
}

class LanguageManager {
    static let shared = LanguageManager()
    
    var m_LanguageType: LanguageType = .chinese
    
    var m_LanguageName: String {
        return m_LanguageType.name
    }
    
    fileprivate lazy var __once: () = {
        object_setClass(Bundle.main, SMBundle.classForCoder())
    }()
    
    func setup() {
        refreshLanguageSetting()
    }
    
    func setLanguage(type: LanguageType) {
        refreshLanguageSetting()
    }
    
    fileprivate func refreshLanguageSetting() {
        m_LanguageType = .chinese
        
        var _ : Int = 0
        _ = self.__once

        var bundle : Bundle? = nil
        guard let path = Bundle.main.path(forResource: m_LanguageType.rawValue, ofType: "lproj") else { return }
        bundle = Bundle(path: path)
        objc_setAssociatedObject(Bundle.main, &associatedObjectHandle, bundle, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
    }
    
    class func getLocalizedString(key: String) -> String {
        return Bundle.main.localizedString(forKey: key, value: key, table: "Localizable")
    }
    
    class func getStringInLanguage(language: LanguageType, key: String) -> String {
        
        guard let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj") else { return "" }
        let languageBundle = Bundle(path: path)
        return languageBundle?.localizedString(forKey: key, value: key, table: "Localizable") ?? ""
    }
}

fileprivate var associatedObjectHandle: UInt8 = 0

class SMBundle: Bundle {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        
        if let bundle = objc_getAssociatedObject(self, &associatedObjectHandle) {
            return (bundle as AnyObject).localizedString(forKey: key, value: value, table: tableName)
        } else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
    }
}
