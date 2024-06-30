//
//  LoginViewModel.swift
//  ToDoList
//
//  Created by yuhan on 2024/6/25.
//

import Foundation
import Combine

class LoginViewModel: BaseViewModel {
    
    @Published var strAcc: String = ""
    @Published var strPwd: String = ""
    var successLogin = PassthroughSubject<Void, Never>()
    
    
    func loginProcess() {
        Just((strAcc, strPwd))
            .setFailureType(to: Error.self)
            .tryFilter({ (account, pwd) in
                guard !account.isEmpty && !pwd.isEmpty else {
                    throw YuHanApiError(code: "", description: i18n.Login.Login_Empty_Error)
                }
                return true
            })
            .flatMap({[unowned self] (account, pwd) -> AnyPublisher<LoginResponse?, Error> in
                let req = LoginRequest(account: account, pwd: pwd)
                return callLogin(req: req)
            })
            .handleEvents(receiveSubscription: {[weak self] _ in
                self?.isLoading = true
            }, receiveOutput: { [weak self]  _ in
                self?.isLoading = false
            }, receiveCompletion: { [weak self]  _ in
                self?.isLoading = false
            }, receiveCancel: { [weak self] in
                self?.isLoading = false
            })
            .subscribe(Subscribers.Sink { [unowned self] completion in
                guard case let .failure(error) = completion else { return }
                errorOccurredShowAlert.send(error)
            } receiveValue: { [unowned self] response in
                guard let response = response else { return }
                successLogin.send()
            })
    }
    
    private func callLogin(req: LoginRequest) -> AnyPublisher<LoginResponse?, Error> {
        return provider.login(request: req)
    }
}
