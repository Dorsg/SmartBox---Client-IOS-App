//
//  MainPresenter.swift
//  SmartBox
//
//  Created by Agat Levi on 11/05/2022.
//

import Foundation
import UIKit

class MainPresenter {
    var view: MainViewController?
    
    func checkIfAlreadyLoggedIn() {
        if GlobalManager.instance.userManager.userViewModel != nil {
            Logger.instance.logEvent(type: .login, info: "user is already  logger in")
            view?.openBoxStateViewController()
        }
    }
    
    func signup() {
        Logger.instance.logEvent(type: .signup, info: "starting signup session")
        view?.openSignupViewController()
    }
    
}
