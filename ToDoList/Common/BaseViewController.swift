
import UIKit
import Combine

class BaseViewController: UIViewController, Navigatable {
    
    var navigator: Navigator!
    
    var loading: LoadingViewController! = LoadingViewController()
    private var m_aryPresentQueue: [[String: Any]] = [[:]]

    @Published var bIsPresenting = false
    
    
    override var hidesBottomBarWhenPushed: Bool {
        get { return false == (self.navigationController?.topViewController == self) }
        set { }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    init(navigator: Navigator) {
        self.navigator = navigator
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func initView() {
        
        $bIsPresenting
            .receive(on: DispatchQueue.main)
            .subscribe(Subscribers.Sink { _ in
                
            } receiveValue: { [weak self] isPresenting in
                guard let presentQueue = self?.m_aryPresentQueue else { return }
                guard !isPresenting && !presentQueue.isEmpty else { return }
                if let present = presentQueue.first,
                   let segue = present["segue"] as? Navigator.Scene,
                   let transition = present["transition"] as? Navigator.Transition {
                    let completion = present["completion"] as? (() -> Void)? ?? nil
                    print(present)
                    self?.navigator.show(segue: segue, sender: self, transition: transition, completion: completion)
                }
                self?.m_aryPresentQueue.remove(at: 0)
            })
        
    }
    
    func changeWithRegisterFlag() {}

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    deinit {
        print("\(type(of: self)): Deinited")
    }
    
    // MARK: - Public
    func setLoading(_ isLoading: Bool) {
        guard isLoading else {
            self.loading.dismiss(animated: true) { [weak self] in
                self?.bIsPresenting = false
            }
            return
        }
        
        guard !bIsPresenting else { return }
        
        loading.modalPresentationStyle = .overFullScreen
        loading.modalTransitionStyle = .crossDissolve
        present(loading, animated: true)
        bIsPresenting = true
    }
    
    func changeNextAction(segue: Navigator.Scene,
                          transition: Navigator.Transition = .navigation,
                          completion: (() -> Void)? = nil) {
        let showView = ["segue": segue, "transition": transition, "completion": completion] as [String : Any]
        m_aryPresentQueue.append(showView)
    }
    
}

class BaseViewModelController<ViewModel: BaseViewModel>: BaseViewController {
    
    var viewModel: ViewModel
    var isUsingCommonViewModel: Bool = false
    
    private var bindings = Set<AnyCancellable>()
    
    init(viewModel: ViewModel, navigator: Navigator, isUsingCommonViewModel: Bool = false) {
        self.viewModel = viewModel
        self.isUsingCommonViewModel = isUsingCommonViewModel
        super.init(navigator: navigator)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindViewModel() {
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.setLoading(isLoading)
            }
            .store(in: &bindings)
        
        viewModel.errorOccurredShowAlert
            .receive(on: DispatchQueue.main, options: nil)
            .sink(receiveValue: { [weak self] error in
                self?.showAPIAlert(error)
            })
            .store(in: &bindings)

    }
    
    private func showAPIAlert(_ error: Error?) {
        var messase: String? = ""
        if let apiError = error as? YuHanApiError {
            messase = apiError.description
        } else {
            messase = error?.localizedDescription
        }
        changeNextAction(segue: .alert(description: messase), transition: .alert)
    }
    
    
    func initNavigationBar(_ strTitle: String) {
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.backItem?.backButtonTitle = ""
        
        title = strTitle
    }
    
    func initNavRightButton() {
        // 背景透明
        let image = UIImage()
        navigationController?.navigationBar.setBackgroundImage(image, for: .default)
        navigationController?.navigationBar.shadowImage = image
    }
    
}

func openSetting() {
    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
        return
    }
    if UIApplication.shared.canOpenURL(settingsUrl) {
        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { exit(0) }
        })
    }
}
