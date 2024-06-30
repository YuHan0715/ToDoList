
import UIKit
import Combine

final class Application {
    static let shared = Application()

    var window: UIWindow?

    private var m_bindings = Set<AnyCancellable>()
    
    var provider: YuHanAPI?
    let navigator: Navigator

    init() {
        navigator = Navigator.default
        updateProvider()
    }
    
    private func updateProvider() {
        let staging = Configs.Network.useStaging
        let yuhanProvider = staging ? YuHanNetworking.stubbingNetworking() : YuHanNetworking.defaultNetworking()
        let restApi = RestApi(yuhanProvider: yuhanProvider)
        provider = restApi
        
    }

    func presentInitialScreen(in window: UIWindow?) {
        guard let window = window, let provider = provider else { return }
        self.window = window
        
        DispatchQueue.main.asyncAfter(deadline: Animations.Delay.ms500) { [weak self] in
            let viewModel = LoginViewModel(provider: provider)
            self?.navigator.show(segue: .login(viewModel: viewModel), sender: nil, transition: .root(in: window))
//            let viewModel = HomeViewModel(provider: provider)
//            self?.navigator.show(segue: .home(viewModel: viewModel), sender: nil, transition: .root(in: window))
        }
    }
    
}
