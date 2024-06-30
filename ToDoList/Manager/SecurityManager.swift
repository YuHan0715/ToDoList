
import Foundation
import UIKit

class SecurityManager {
    // MARK: - 模擬器判斷
    class func isSimulator() -> Bool {
        var isSimulator = false
#if targetEnvironment(simulator) && !DEBUG
        isSimulator = true
#endif
        return isSimulator
    }
    
    // MARK: - APP JB判斷
    class func isJailBroken() -> Bool {
        
        return JBCheck.isJailbroken() || JBCheck.checkPlistCrackKeyValue()
    }
}

private class JBCheck {
    class func isJailbroken() -> Bool {
        if (TARGET_IPHONE_SIMULATOR == 0) && (TARGET_OS_SIMULATOR == 0) {
            let fileManager = FileManager.default
            
            if fileManager.fileExists(atPath: "/Applications/Cydia.app") ||
                fileManager.fileExists(atPath: "/Library/MobileSubstrate/MobileSubstrate.dylib") ||
                fileManager.fileExists(atPath: "/bin/bash") ||
                fileManager.fileExists(atPath: "/bin/sh") ||
                fileManager.fileExists(atPath: "/usr/sbin/sshd") ||
                fileManager.fileExists(atPath: "/usr/libexec/ssh-keysign") ||
                fileManager.fileExists(atPath: "/etc/apt") ||
                fileManager.fileExists(atPath: "/etc/ssh/sshd_config") ||
                fileManager.fileExists(atPath: "/private/var/lib/apt/") ||
                fileManager.fileExists(atPath: "/var/cache/apt") ||
                fileManager.fileExists(atPath: "/var/lib/apt") ||
                fileManager.fileExists(atPath: "/var/lib/cydia") ||
                fileManager.fileExists(atPath: "/var/log/syslog") ||
                fileManager.fileExists(atPath: "/var/tmp/cydia.log") ||
                UIApplication.shared.canOpenURL(URL(string: "cydia://")!) {
                return true
            }
        
            if canOpen("/Applications/Cydia.app") ||
                canOpen("/Library/MobileSubstrate/MobileSubstrate.dylib") ||
                canOpen("/bin/bash") ||
                canOpen("/usr/sbin/sshd") ||
                canOpen("/etc/apt") ||
                canOpen("/usr/bin/ssh") {
                    return true
            }
            
            let path = "/private/" + NSUUID().uuidString
            do {
                try "anyString".write(toFile: path, atomically: true, encoding: .utf8)
                try fileManager.removeItem(atPath: path)
                return true
            } catch _ as NSError {
                return false
            }
        }
        
        return false
    }
    
    class func checkPlistCrackKeyValue() -> Bool {
        if (TARGET_IPHONE_SIMULATOR == 0) && (TARGET_OS_SIMULATOR == 0) {
            let bundle: Bundle = Bundle.main
            let info: [String: Any]? = bundle.infoDictionary
            
            if info?["SignerIdentity"] != nil ||
                info?["nilFvtareVqragvgl"] != nil {
                return true
            }
        }
        
        return false
    }
    
    static func canOpen( _ path: String) -> Bool {
        let file = FileManager.default.contents(atPath: path)
        guard file != nil else { return false }
        return true
    }
}
