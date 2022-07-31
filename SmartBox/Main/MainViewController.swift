//
//  MainViewController.swift
//  SmartBox
//
//  Created by Agat Levi on 11/05/2022.
//

import UIKit

class MainViewController: UIViewController {
    let presenter: MainPresenter = MainPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        presenter.checkIfAlreadyLoggedIn()
    }
    
    @IBAction func signupButtonTapped(_ sender: UIButton) {
        presenter.signup()
    }
    
    
    func openSignupViewController() {
        let signupStoryboard = UIStoryboard(name: "Signup", bundle: nil)
        let signupVC = signupStoryboard.instantiateViewController(withIdentifier: "Signup") as! SignupViewController
        let signupPresenter = SignupPresenter(viewModel: SignupViewModel(),view: signupVC, manager: GlobalManager.instance.loginManager)
        signupVC.presenter = signupPresenter
        navigationController?.pushViewController(signupVC, animated: true)
    }
    
    func openBoxStateViewController() {
        guard let userVM = GlobalManager.instance.userManager.userViewModel,
                let boxId = userVM.boxId,
                let threshold = userVM.boxBaseline,
                let currentWeight = userVM.currentWeight
        else {
            Logger.instance.logEvent(type: .login, info: "openBoxStateVC failed because of an empty userVM")
            return
        }
        
        let boxStateStoryboard = UIStoryboard(name: "BoxState", bundle: nil)
        let boxStateVC = boxStateStoryboard.instantiateViewController(withIdentifier: "BoxState") as! BoxStateViewController
        let boxStatePresenter = BoxStatePresenter(viewModel: BoxStateViewModel(boxID: boxId, currentWeight: currentWeight, threshold: threshold), view: boxStateVC)
        boxStateVC.presenter = boxStatePresenter
        navigationController?.pushViewController(boxStateVC, animated: true)
    }
}


