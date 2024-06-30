//
//  LibsManager.swift
//  ToDoList
//
//  Created by yuhan on 2024/6/26.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift

/// The manager class for configuring all libraries used in app.
class LibsManager: NSObject {

    /// The default singleton instance.
    static let shared = LibsManager()
    
    private override init() {
        super.init()
    }
    
    func setupLibs(with window: UIWindow? = nil) {
        let libsManager = LibsManager.shared
        libsManager.setupKeyboardManager()
        libsManager.setupLanguageManager()
    }
    
    func setupKeyboardManager() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
    }
    
    func setupLanguageManager() {
        LanguageManager.shared.setup()
    }
}
