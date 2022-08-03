//
//  LoginPresenter.swift
//  SmartBox
//
//  Created by agat levi on 12/03/2022.
//

import Foundation

protocol LoginPresenterView: AnyObject {
    func update(viewModel: LoginViewModel)
}

class LoginPresenter {
    private weak var view: LoginViewController?
    private let viewModel: LoginViewModel
    private let loginManager: LoginManagerProtocol
    
    init(view: LoginViewController, viewModel: LoginViewModel, loginManager: LoginManagerProtocol) {
        self.view = view
        self.viewModel = viewModel
        self.loginManager = loginManager
    }
    
    func attachView(_ view: LoginViewController) {
        self.view = view
        self.view?.update(viewModel: viewModel)
    }
        
    func detachView() {
        self.view = nil
    }
    
    func login(with username: String, and password: String) {
        loginManager.getSignIn(username: username, password: password, success: { [weak self] in
            Logger.instance.logEvent(type: .login, info: "getSignIn success")
            GlobalManager.instance.userManager.userLoggedIn(email: username, password: password, success: {
                Logger.instance.logEvent(type: .login, info: "userLoggedIn success, finished getUserInfo")
                self?.view?.openBoxStateViewController()
            }, failure: { [weak self] error, response in
                Logger.instance.logEvent(type: .login, info: "userLoggedIn failed")
                if let responseObject = response {
                    do {
                        let data = try  JSONSerialization.data(withJSONObject: responseObject, options: [])
                        if let response = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any], let err = response["error"] as? String {
                            self?.view?.showLoginFailedAlert(error: err )
                        }
                    } catch _ {
                        self?.view?.showLoginFailedAlert(error: error?.localizedDescription ?? "unkown error" )
                    }
                } else {
                    self?.loginFailedBecauseOfMissingConfiguration()
                }
            })
        }, failure: { [weak self] error, response in
            Logger.instance.logEvent(type: .login, info: "getSignIn failed")
            if let responseObject = response {
                do {
                    let data = try  JSONSerialization.data(withJSONObject: responseObject, options: [])
                    if let response = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any], let err = response["error"] as? String {
                        self?.view?.showLoginFailedAlert(error: err )
                    }
                } catch _ {
                    self?.view?.showLoginFailedAlert(error: error?.localizedDescription ?? "unkown error" )
                }
            }
        })
    }
    
    private func loginFailedBecauseOfMissingConfiguration() {
        view?.showMissingConfigurationAlert()
    }
}
