
import Foundation

private func _i18n(_ string: String) -> String {
    return  LanguageManager.getLocalizedString(key: string)
}

struct i18n {
    
    struct Api {
        static var Error_Timeout: String { _i18n("API_Error_Timeout") }
        static var Error_StatusCode: String { _i18n("API_Error_StatusCode") }
    }

    struct Alert {
        static var Error_Title: String { _i18n("Alert_Error_Title") }
        static var Confirm_Title: String { _i18n("Alert_Confirm_Title") }
    }

    struct Login {
        static var Account_Placeholder: String { _i18n("Login_Account_Placeholder") }
        static var Password_Placeholder: String { _i18n("Login_Password_Placeholder") }
        static var Login_Empty_Error: String { _i18n("Login_Empty_Error") }
    }
}
