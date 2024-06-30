
import UIKit
import EventKit
import Contacts
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    static var shared: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0
        }
        
        let libsManager = LibsManager.shared
        libsManager.setupLibs(with: window)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        Application.shared.presentInitialScreen(in: window)
        
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return true
    }
    
    // Dynamic Links
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        return true
    }
    
}

// MARK: 推播相關
extension AppDelegate {
    
    /// 接收Token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
//        UserManager.shared.m_tempPushToken = deviceToken.hexEncodedString()
//        Messaging.messaging().apnsToken = deviceToken
    }
    
    /// 推播註冊失敗
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("APNs registration failed: \(error.localizedDescription)")
    }
    
    /// 註冊APNs
    private func registerRemoteNotification() {
        
        let center: UNUserNotificationCenter = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.sound, .alert, .badge]) { (success, error) -> Void in
            if let err = error {
                
                print("registerRemoteNotification error: \(err.localizedDescription)")
            } else {
                
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // App 在前景時，推播送出時即會觸發的 delegate
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("------Notitfication UserInfo Front------")
        completionHandler([.sound, .alert, .badge])
    }
    
    // App 在關掉的狀態下或 App 在背景或前景的狀態下，點擊推播訊息時所會觸發的 delegate
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        
        print("------Notitfication UserInfo Back------")
        print(userInfo)

        let didOpenNotificationName = Notification.Name(rawValue: "OpenNotification")
        NotificationCenter.default.post(name: didOpenNotificationName, object: nil, userInfo: userInfo)
    }
}

//extension AppDelegate: MessagingDelegate {
//    
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        
//        let pushToken = fcmToken ?? ""
//        print("pushToken is Here~~~~: \(pushToken)")
//    }
//    
//}
