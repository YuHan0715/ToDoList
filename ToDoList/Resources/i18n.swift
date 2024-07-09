
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
    
    struct Task {
        static var Priority_Hight: String { _i18n("Task_Priority_Hight") }
        static var Priority_Mid: String { _i18n("Task_Priority_Mid") }
        static var Priority_Low: String { _i18n("Task_Priority_Low") }
    }

    struct Login {
        static var Account_Placeholder: String { _i18n("Login_Account_Placeholder") }
        static var Password_Placeholder: String { _i18n("Login_Password_Placeholder") }
        static var Login_Empty_Error: String { _i18n("Login_Empty_Error") }
    }
    
    struct Home {
        static var Search_Placeholder: String { _i18n("Home_Search_Placeholder") }
    }
    
    struct Edit {
        static var Title: String { _i18n("Edit_Title") }
        static var Title_Placeholder: String { _i18n("Edit_Title_Placeholder") }
        static var DueDate: String { _i18n("Edit_DueDate") }
        static var DueDate_Placeholder: String { _i18n("Edit_DueDate_Placeholder") }
        static var Category: String { _i18n("Edit_Category") }
        static var Category_Placeholder: String { _i18n("Edit_Category_Placeholder") }
        static var Priority: String { _i18n("Edit_Priority") }
        static var Priority_Placeholder: String { _i18n("Edit_Priority_Placeholder") }
        static var SubTask: String { _i18n("Edit_SubTask") }
        static var SubTask_Placeholder: String { _i18n("Edit_SubTask_Placeholder") }
        static var Description: String { _i18n("Edit_Description") }
        static var Description_Placeholder: String { _i18n("Edit_Description_Placeholder") }
    }
}
