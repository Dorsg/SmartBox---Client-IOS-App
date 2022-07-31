//
//  SignupViewController.swift
//  SmartBox
//
//  Created by Agat Levi on 11/05/2022.
//

import UIKit

class SignupViewController: UIViewController {
    var presenter: SignupPresenter!

    @IBOutlet var loadinAnimation: UIActivityIndicatorView!
    @IBOutlet var signupButton: UIButton!
    @IBOutlet var passwordTextbox: UITextField!
    @IBOutlet var usernameTextbox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadinAnimation.stopAnimating()
        signupButton.isHidden = false
        presenter.attachView(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.detachView()
    }
    
    @IBAction func signupButtonTapped(_ sender: Any) {
        loadinAnimation.startAnimating()
        signupButton.isHidden = true
        
        guard let password = passwordTextbox.text else { return }
        guard let username = usernameTextbox.text else { return }
        if !username.isValidEmail() {
            let okAction = UIAlertAction(title: "Let me fix it", style: .default, handler: nil)
            showAlertViewController(title: "Invalid input", message: "Your email looks fishy, are you sure it is correct?", actions: [okAction], animated: true, completion: {
                self.loadinAnimation.stopAnimating()
                self.signupButton.isHidden = false
            })
            return
        }
        
        presenter.signup(username: username, password: password)
    }
    
    
    func openSettingsViewController(){
        let settingsStoryboard = UIStoryboard(name: "Settings", bundle: nil)
        let settingsVC = settingsStoryboard.instantiateViewController(withIdentifier: "Settings") as! SettingsViewController
        let presenterSettings = SettingsPresenter(with: settingsVC, settingsManager: GlobalManager.instance.settingsManager)
        settingsVC.presenter = presenterSettings
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    func showSignupFailedAlert(error: String) {
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        showAlertViewController(title: "Signup failed", message: error, actions: [okAction], animated: true, completion: {
            self.loadinAnimation.stopAnimating()
            self.signupButton.isHidden = false
        })
        return
    }

}

extension SignupViewController {
    func update(viewModel: SignupViewModel) {
        //TODO:
    }
}
