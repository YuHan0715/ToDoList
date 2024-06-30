//
//  LoginViewController.swift
//  ToDoList
//
//  Created by yuhan on 2024/6/25.
//

import UIKit
import Combine

class LoginViewController: BaseViewModelController<LoginViewModel> {
    
    @IBOutlet weak var tfAccount: UITextField!
    @IBOutlet weak var tfPwd: UITextField!
    @IBOutlet weak var btnForgetPwd: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnAppleLogin: UIButton!
    @IBOutlet weak var btnGoogleLogin: UIButton!
    @IBOutlet weak var btnFacebookLogin: UIButton!
    
    var aryBindings = Set<AnyCancellable>()
    
    override func initView() {
        super.initView()
        
        tfAccount.placeholder = i18n.Login.Account_Placeholder
        tfPwd.placeholder = i18n.Login.Password_Placeholder
        btnLogin.addCornerRadius()
    }
    
    override func bindViewModel() {
        super.bindViewModel()

        tfAccount.textPublisher
            .replaceNil(with: "")
            .receive(on: DispatchQueue.main)
            .sink {[weak self] acc in
                self?.viewModel.strAcc = acc
            }
            .store(in: &aryBindings)
        
        
        tfPwd.textPublisher
            .replaceNil(with: "")
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] pwd in
                self?.viewModel.strPwd = pwd
            })
            .store(in: &aryBindings)
        
        btnLogin.publisher(for: .touchUpInside)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                self?.viewModel.loginProcess()
            })
            .store(in: &aryBindings)
        
        viewModel.successLogin
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] in
                guard let window = Application.shared.window else { return }
                let homeViewModel = HomeViewModel(provider: viewModel.provider)
                changeNextAction(segue: .home(viewModel: homeViewModel), transition: .root(in: window))
            })
            .store(in: &aryBindings)
    }

}
