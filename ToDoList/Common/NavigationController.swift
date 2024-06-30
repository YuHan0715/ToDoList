
import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        interactivePopGestureRecognizer?.delegate = nil // Enable default iOS back
    }
    
    func checkNavigationImage(toPop: Bool = true, toRoot: Bool = false) {
        if toRoot {
            hideNavigationImage()
            return
        }
        if self.viewControllers.count > (toPop ? 2:1) {
            showNavigationImage()
        } else {
            hideNavigationImage()
        }
    }
    
    func showNavigationImage() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
    
    func hideNavigationImage() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        checkNavigationImage(toPop: false)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        checkNavigationImage()
        return super.popViewController(animated: animated)
    }
    
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        checkNavigationImage(toRoot: true)
        return super.popToRootViewController(animated: animated)
    }
}
