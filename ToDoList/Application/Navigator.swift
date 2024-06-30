
import UIKit
import SafariServices

protocol Navigatable {
    var navigator: Navigator! { get set }
}

class Navigator {
    static var `default` = Navigator()

    // MARK: - segues list, all app scenes
    enum Scene {
        case login(viewModel: LoginViewModel)
        case home(viewModel: HomeViewModel)
        case alert(description: String?)
        case picker(viewModel: PickerViewModel)
        /// (外開)手機設定
        case phoneSetting
        /// (外開)Safari
        case safari(URL)
    }

    enum Transition {
        case root(in: UIWindow)
        case navigation
        case customModal(custom:(navigation: Bool ,
                                 transition: UIModalTransitionStyle,
                                 presentation: UIModalPresentationStyle))
        case modal
        case detail
        case alert
        case forceAlert
        case dismiss
        case custom
    }

    // MARK: - get a single VC
    func get(segue: Scene) -> UIViewController? {
        switch segue {
        case .login(let viewModel):
            let vc = LoginViewController(viewModel: viewModel, navigator: self)
            return vc
            
        case .home(let viewModel):
            let vc = HomeViewController(viewModel: viewModel, navigator: self)
            return vc
            
        case .alert(let description):
            let vc = UIAlertController()
            let confirmActoin = UIAlertAction(title: i18n.Alert.Confirm_Title, style: .default)
            vc.title = i18n.Alert.Error_Title
            vc.message = description
            vc.addAction(confirmActoin)
            return vc
            
        case .picker(let viewModel):
            let vc = PickerViewController(viewModel: viewModel, navigator: self)
            return vc
        case .phoneSetting:
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
            return nil
            
        case .safari(let url):
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            return nil
        }
    }

    func pop(sender: UIViewController?, toRoot: Bool = false) {
        if toRoot {
            sender?.navigationController?.popToRootViewController(animated: true)
        } else {
            sender?.navigationController?.popViewController(animated: true)
        }
    }

    func popTo(sender: UIViewController?, to targetVc: UIViewController) {
        guard let viewControllers = sender?.navigationController?.viewControllers else { return }
        if viewControllers.contains(targetVc) {
            sender?.navigationController?.popToViewController(targetVc, animated: true)
        }
    }

    func dismiss(sender: UIViewController?, completion: (() -> Void)? = nil) {
        sender?.navigationController?.dismiss(animated: true, completion: completion)
    }

    // MARK: - invoke a single segue
    func show(segue: Scene, sender: UIViewController?, transition: Transition = .navigation, completion: (() -> Void)? = nil) {
        if let target = get(segue: segue) {
            show(target: target, sender: sender, transition: transition, completion: completion)
        }
    }

    private func show(target: UIViewController, sender: UIViewController?, transition: Transition, completion: (() -> Void)?) {
        switch transition {
        case .root(in: let window):
            window.rootViewController = target
            window.makeKeyAndVisible()
            return
        case .custom: return
        default: break
        }

        guard let sender = sender else {
            fatalError("You need to pass in a sender for .navigation or .modal transitions")
        }

        if let nav = sender as? UINavigationController {
            // push root controller on navigation stack
            nav.pushViewController(target, animated: false)
            return
        }

        switch transition {
        case .navigation:
            if let nav = sender.navigationController {
                // push controller to navigation stack
                nav.pushViewController(target, animated: true)
            }
        case .customModal(let custom):
            // present modally with custom animation
            DispatchQueue.main.async {

                if custom.navigation == true {
                    let nav = NavigationController(rootViewController: target)
                    nav.modalPresentationStyle = custom.presentation
                    nav.modalTransitionStyle = custom.transition
                    sender.present(nav, animated: true, completion: completion)
                } else {
                    target.modalPresentationStyle = custom.presentation
                    target.modalTransitionStyle = custom.transition
                    sender.present(target, animated: true, completion: completion)
                }
            }
        case .modal:
            // present modally
            DispatchQueue.main.async {
                let nav = NavigationController(rootViewController: target)
                sender.present(nav, animated: true, completion: completion)
            }
        case .detail:
            DispatchQueue.main.async {
                let nav = NavigationController(rootViewController: target)
                sender.showDetailViewController(nav, sender: nil)
            }
        case .alert:
            DispatchQueue.main.async {
                sender.present(target, animated: true, completion: completion)
            }
        case .forceAlert:
            // isModalInPresentation = true 使 alert 不能用下滑手勢關閉
            DispatchQueue.main.async {
                target.isModalInPresentation = true
                sender.present(target, animated: true, completion: completion)
            }
        case .dismiss:
            DispatchQueue.main.async {
                sender.dismiss(animated: true, completion: completion)
            }
        default: break
        }
    }
}
