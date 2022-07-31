//
//  SignupPresenter.swift
//  SmartBox
//
//  Created by Agat Levi on 11/05/2022.
//

import Foundation

class SignupPresenter {
    var view: SignupViewController?
    var manager: LoginManagerProtocol
    var viewModel: SignupViewModel //{
//        didSet {
//            viewModel != oldValue {
//                view?.update(viewModel: viewModel)
//            }
//        }
//    }
    
    init(viewModel: SignupViewModel, view: SignupViewController, manager: LoginManagerProtocol) {
        self.viewModel = viewModel
        self.view = view
        self.manager = manager
    }
    
    func attachView(_ view: SignupViewController) {
        self.view = view
        self.view?.update(viewModel: viewModel)
    }
        
    func detachView() {
        self.view = nil
    }
    
    func signup(username: String, password: String) {
        manager.postSignup(username: username, password: password, success: {
            Logger.instance.logEvent(type: .login, info: "postSignup success")
            GlobalManager.instance.userManager.userSignedUp(email: username, password: password)
            self.view?.openSettingsViewController()
        }, failure: { error, response in
            Logger.instance.logEvent(type: .login, info: "postSignup failed")
            if let responseObject = response {
                do {
                    let data = try  JSONSerialization.data(withJSONObject: responseObject, options: [])
                    if let response = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any], let err = response["error"] as? String {
                        self.view?.showSignupFailedAlert(error: err )
                    }
                } catch _ {
                    self.view?.showSignupFailedAlert(error: error?.localizedDescription ?? "unkown error" )
                }
            }
        })
    }
    
}
