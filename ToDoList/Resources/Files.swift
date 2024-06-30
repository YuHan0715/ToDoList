
import UIKit

struct Files {
    struct Image {
        static let iLoginIcon: UIImage = #imageLiteral(resourceName: "stickyNote")
        static let iGoogleLogin: UIImage = #imageLiteral(resourceName: "stickyNote")
        static let iFacebookLogin: UIImage = #imageLiteral(resourceName: "facebook")
        static let iAppleLogin: UIImage = #imageLiteral(resourceName: "apple")
        static let iChecked: UIImage = #imageLiteral(resourceName: "checked")
        static let iUnchecked: UIImage = #imageLiteral(resourceName: "unchecked")
    }
    
    struct Json {
        static var Login: Data? { Bundle.main.data(forJsonResource: "Login") }
        
        static var GetOption: Data? { Bundle.main.data(forJsonResource: "GetOption") }
        
        static var GetToDoList: Data? { Bundle.main.data(forJsonResource: "GetToDoTasks") }
    }
}
